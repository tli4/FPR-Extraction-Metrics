require 'rails_helper'

RSpec.describe CourseNameController, type: :controller do

  it "redirects the user to the login page if they are unauthenticated" do
    sign_out @user
    get :index
    expect(response).to redirect_to(new_user_session_path)
  end

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET #new" do
    it "responds unsuccessfully if subject_course parameter is unset" do
      expect { get :new }.to raise_error(ActionController::ParameterMissing)
    end

    it "responds successfully if the subject_course parameter is set" do
      get :new, subject_course: "CSCE 121"
      expect(response).to be_success
    end

    it "assigns a newly created CourseName if one doesn't exist for the course and subject" do
      get :new, subject_course: "CSCE 121"
      expect(assigns(:course_name).subject_course).to eq("CSCE 121")
    end

    it "assigns a loaded instance of CourseName if one matches for this course and subject" do
      cn = FactoryGirl.create(:course_name, subject_course: "CSCE 121", name: "Cool Course")
      get :new, subject_course: "CSCE 121"
      expect(assigns(:course_name)).to eq(cn)
    end

  end

  describe "POST #create" do
    it "creates a new CourseName if one doesn't exist for the course and subject and attributes are valid" do
      previous_count = CourseName.count
      post :create, course_name: { subject_course: "CSCE 121", name: "MyCoolCourse" }
      expect(CourseName.count).to eq(previous_count + 1)
    end

    it "updates a CourseName if one already exists for the course and subject" do
      cn = FactoryGirl.create(:course_name, subject_course: "CSCE 121", name: "A dreary course")
      previous_count = CourseName.count
      post :create, course_name: { subject_course: "CSCE 121", name: "MyCoolCourse" }

      cn.reload
      expect(CourseName.count).to eq(previous_count)
      expect(cn.name).to eq("MyCoolCourse")
    end

    it "renders the new template again if parameters are invalid" do
      previous_count = CourseName.count
      post :create, course_name: { subject_course: "BOGUS 9999", name: "A bogus course." }
      expect(response).to render_template('new')
      expect(CourseName.count).to eq(previous_count)
    end
  end

  describe "GET #index" do
    it "assigns all unique courses even if they don't have a course name" do
      FactoryGirl.create(:evaluation, subject: "CSCE", course: "121")
      FactoryGirl.create(:evaluation, subject: "CSCE", course: "121")
      FactoryGirl.create(:evaluation, subject: "CSCE", course: "181")
      get :index
      expect(assigns(:courses).count).to eq(2)
    end
  end

  describe "GET #import" do
    it "renders the pretty centered form template" do
      get :import
      expect(response).to render_template 'layouts/centered_form'
    end
  end

  describe "POST #upload" do
    it "fails gracefully for non .xlsx fils" do
      @file = fixture_file_upload('/random.dat', 'application/octet-stream')
      post :upload, data_file: @file
      expect(response).to redirect_to(import_course_name_index_path)
      expect(flash[:errors]).to_not be(nil)
    end

    it "gracefully rejects malformatted .xlsx files" do
      @file = fixture_file_upload('/malformed_course_name.xlsx', 'application/vnd.ms-excel')
      post :upload, data_file: @file
      expect(response).to redirect_to(import_course_name_index_path)
      expect(flash[:errors]).to_not be(nil)
    end

    it "accepts .xlsx files for uploading" do
      @file = fixture_file_upload('/course_names.xlsx', 'application/vnd.ms-excel')
      post :upload, data_file: @file
      expect(response).to redirect_to("/course_name")
    end

    it "creates the correct evaluation records for the test data" do
      @file = fixture_file_upload('/course_names.xlsx', 'application/vnd.ms-excel')
      post :upload, data_file: @file
      expect(CourseName.where(subject_course: 'CSCE 111').first_or_initialize.name).to eq('Introduction to Algorithms')
    end
  end

end
