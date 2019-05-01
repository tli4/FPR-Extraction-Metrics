class InstructorController < ApplicationController
  include InstructorHelper

  before_action :authenticate_user!
  before_action :verify_read

  def index
    # return the instructors in sorted order by last name
    instructors_with_enrollment_data = Evaluation.no_missing_data.pluck(:instructor_id).uniq
    @instructors =Instructor.where(id: instructors_with_enrollment_data).sort { |a, b| a.name.split(" ").last <=> b.name.split(" ").last }
    #logger.debug "New name: #{@instructors}"
    # if params[:status]
    #   redirect_to instructor_index_path
    #   redirect_to :back
    # end
    @inactive_instructors = inst_list("status = 'Inactive'")
  end

  def show
    @instructor = Instructor.find(id)
    @instructor_course_groups = @instructor.course_section_groups.sort { |group1, group2| group2.first.term <=> group1.first.term }
    @all_course_groups = Evaluation.no_missing_data.default_sorted_groups
  end
  
  def update
    @instructor = Instructor.find(id)

    @instructor.assign_attributes({:status => params[:instructor][:status]})
    @instructor.save

    redirect_to instructor_path(id)
    # redirect_to instructor_index_path
  end

  def combine
    #@instructor = Instructor.find(id)
    # flash[:notice] = "combine function called."
    # redirect_to combine_instructor_index_path
  end

  def merge
    if not params[:id].nil?
      session[:instructor_combine_id] = id
      redirect_to merge_confirm_instructor_index_path
    else
      flash[:notice] = "No instructor is selected. Combine operation is cancelled."
      redirect_to instructor_index_path
    end
  end

  def merge_confirm

    if(params[:commit].eql? "Cancel")
      flash[:notice] = "Combine operation is cancelled. "
      redirect_to instructor_index_path
    end

    @instructor_combine = Instructor.find(session[:instructor_combine_id])

    if params[:commit].eql? "Combine"
      @instructor_combine_ids = session[:instructor_combine_id]
      @instructor_keep_id = [params[:name]]
      @instructor_delete_ids = @instructor_combine_ids - @instructor_keep_id

      @instructor_delete_ids.each do |id|
        Evaluation.where(instructor_id: id).update_all(instructor_id:  @instructor_keep_id[0])
      end

      @instructor_delete_ids.each do |id|
        Instructor.find(id).destroy
      end
      flash[:notice] = "Combine operation is successful. "
      redirect_to instructor_index_path
    end

  end
  
  def create
    if not params[:instructor_ids].nil?
      params[:instructor_ids].each do |id|
        instructor = Instructor.find(id.to_i)
        instructor.assign_attributes({:status => params[:status]})
        instructor.save
      end
    end
    redirect_to instructor_index_path
  end

  def export
    instructor = Instructor.find(id)
    evaluation_groups = Evaluation.no_missing_data.default_sorted_groups
    send_data InstructorReportExporter.new(instructor,evaluation_groups).generate, filename: "#{instructor.name}_instructor_report_#{Time.now.strftime('%F')}.csv"
  end

  private
  def id
    params.require(:id)
  end

  def verify_read
    unless can? :read, :all
      redirect_to root_path
    end
  end
end
