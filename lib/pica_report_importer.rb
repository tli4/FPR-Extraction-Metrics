require 'roo'
require 'roo-xls'
require 'rubyXL'
require 'fileutils'

class PicaReportImporter

  class MalformedFileException < RuntimeError
    def to_s
      "Your file appears to be invalid. Please make sure each of the columns are present: " +
          ::PicaReportImporter::DESIRED_DATA.map(&:to_s).join(", ")
    end
  end

  # These are symbolized version of the expected column headings of all the data we care about.
  # TODO: in the future, it might be nice to make these configurable by the user
  DESIRED_DATA = [
    :term, :subject, :course, :sect, :instructor, :responses, :enrollment,
    :item1_mean, :item2_mean, :item3_mean, :item4_mean,
    :item5_mean, :item6_mean, :item7_mean, :item8_mean
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
      raise "There was an error parsing your Excel f    ile. Maybe it is corrupt?"
    end
  end


  def import
    @results = EvaluationImportUtils.import(evaluation_hashes)
  end

  def results
    num_new_records = @results.count { |result| result[:status] == true }
    num_updated_records = @results.count { |result| result[:status] == false }
    num_failed_records = @results.count { |result| result[:status] == :failure }

    { created: num_new_records, updated: num_updated_records, failed: num_failed_records }
  end

  private
  def evaluation_hashes
    @evaluation_hashes ||= parse_sheet
  end

  def parse_sheet
    evaluations = []

    if @extension == 'xlsx'
      sheet = @workbook.first

      # figure out the columns of the data from the headers
      column_header_indices = {}
      sheet[0].cells.each_with_index do |cell, i|
        column_header_indices[cell.value.downcase.to_sym] = i
      end

      sheet.each_with_index do |row, row_num|
        # skip the first row. It's just column headings
        next if row_num == 0

        evaluation = {}
        DESIRED_DATA.each do |data_type|
          row_index = column_header_indices[data_type]
          raise MalformedFileException.new if row_index.nil?
          cell = row.cells[row_index]

          data_type = RENAMES[data_type] if RENAMES[data_type]
          evaluation[data_type] = cell && cell.value
        end

        evaluations.push(evaluation) if evaluation.values.reject(&:nil?).size > 0
      end
    elsif @extension == 'xls'
      @workbook.default_sheet = @workbook.sheets.first

      # figure out the columns of the data from the headers
      column_header_indices = {}

      @workbook.row(1).each_with_index { |header, i|
        column_header_indices[header.downcase.to_sym] = i
      }

      ((@workbook.first_row + 1)..@workbook.last_row).each_with_index do |row, row_num|
        evaluation = {}
        DESIRED_DATA.each do |data_type|
          row_index = column_header_indices[data_type]
          raise MalformedFileException.new if row_index.nil?
          cell = @workbook.cell(row_num + 2, row_index + 1)

          data_type = RENAMES[data_type] if RENAMES[data_type]
          if data_type == :course || data_type == :section || data_type == :enrollment
            evaluation[data_type] = cell.to_int
          else
            evaluation[data_type] = cell
          end
        end

        evaluations.push(evaluation) if evaluation.values.reject(&:nil?).size > 0
      end
    end

    evaluations
  end
end
