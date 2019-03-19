require 'roo'
require 'roo'
require 'roo-xls'
require 'rubyXL'
require 'fileutils'

class HistoryReportImporter

  class MalformedFileException < RuntimeError
    def to_s
      "Your file appears to be invalid. Please make sure each of the columns are present: " +
          ::HistoryReportImporter::DESIRED_DATA.map(&:to_s).join(", ")
    end
  end

  # These are symbolized version of the expected column headings of all the data we care about.
  # TODO: in the future, it might be nice to make these configurable by the user
  DESIRED_DATA = [
    :term, :subject, :course, :sect, :instructor, :responses, :enrollment,
    :item1_mean, :item2_mean, :item3_mean, :item4_mean,
    :item5_mean, :item6_mean, :item7_mean, :item8_mean, :mses, :dae, :ang, :dang, :coursestring, :history
  ]

  RENAMES = { :sect => :section }

  def initialize(uploaded_file, filename)
    @extension = filename.split('.').last

    if @extension == 'xlsx'
      @workbook = RubyXL::Parser.parse_buffer(uploaded_file)
    elsif @extension == 'xls'
      file = File.join("public", filename)
      FileUtils.cp uploaded_file.path, file

      @workbook = Roo::Spreadsheet.open(file)

      # currently all files are saved on the server
    else
      raise "There was an error parsing your Excel file. Maybe it is corrupt?"
    end
  end


  def import
    @results = EvaluationImportUtils.import(history_hashes)
  end

  def results
    num_new_records = @results.count { |result| result[:status] == true }
    num_updated_records = @results.count { |result| result[:status] == false }
    num_failed_records = @results.count { |result| result[:status] == :failure }

    { created: num_new_records, updated: num_updated_records, failed: num_failed_records }
  end

  private
  def history_hashes
    @history_hashes ||= parse_sheet
  end

  def parse_sheet
    historys = []

    if @extension == 'xlsx'
      sheet = @workbook.first
      
      # extract instructor name
      firstcell = sheet[0].cells[0].value
      firstname = firstcell.split(' ')[0]
      lastname = firstcell.split(' ')[1]
      name = firstname + " " + lastname

      sheet.each_with_index do |row, row_num|
        # skip the first row. It's just column headings
        next if row_num == 0 || row_num ==1

        history = {}
        
        record = []
        (0..7).each do |i|
          record[i] = row.cells[i].value
        end
        
        decompose = []
        # term
        term = record[1].to_s.downcase
        if term == "spring"
          s = "A"
        elsif term == "summer"
          s = "B"
        elsif term == "fall"
          s = "C"
        end
        decompose[0] = record[2].to_s + s.to_s
        # subject and course
        subcourse = record[0].split(' ')
        decompose[1] = subcourse[0]
        if subcourse.length == 2
          coursename = subcourse[1]
        else
          coursename = subcourse[1]+subcourse[2]
        end
        coursenum = coursename[0..2]
        decompose[2] = coursenum.to_i
        # sect
        decompose[3] = 0
        # instructor
        decompose[4] = name
        # response
        decompose[5]= 0
        # enrollment
        decompose[6] = record[3]
        # items
        (7..14).each do |i|
          decompose[i] = 0
        end
        # mses
        decompose[15] = record[4]
        # dae
        decompose[16] = record[5]
        # ang
        decompose[17]= record[6]
        # dang
        decompose[18] = record[7]
        # history
        decompose[19] = coursename
        decompose[20] = 1
        
        
        (0..20).each do |i|
          data_type = DESIRED_DATA[i].to_sym
          data_type = RENAMES[data_type] if RENAMES[data_type]
          
          history[data_type] = decompose[i]
        end
        historys.push(history) if history.values.reject(&:nil?).size > 0
        # Rails.logger.info "testtest #{@historys.inspect}"
      end
    elsif @extension == 'xls'
      @workbook.default_sheet = @workbook.sheets.first

      # figure out the columns of the data from the headers
      column_header_indices = {}

      @workbook.row(1).each_with_index { |header, i|
        column_header_indices[header.downcase.to_sym] = i
      }

      ((@workbook.first_row + 1)..@workbook.last_row).each_with_index do |row, row_num|
        history = {}
        DESIRED_DATA.each do |data_type|
          row_index = column_header_indices[data_type]
          raise MalformedFileException.new if row_index.nil?
          cell = @workbook.cell(row_num + 2, row_index + 1)

          data_type = RENAMES[data_type] if RENAMES[data_type]
          if data_type == :course || data_type == :section || data_type == :enrollment
            history[data_type] = cell.to_int
          else
            history[data_type] = cell
          end
        end

        historys.push(history) if history.values.reject(&:nil?).size > 0
      end
    end
    historys
  end
end
