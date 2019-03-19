require 'rails_helper'

RSpec.describe EvaluationController, type: :controller do

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
    it "responds successfully with an HTTP 200 status code" do
      get :new
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "assigns @evaluation" do
      get :new
      expect(assigns(:evaluation)).to_not be(nil)
      expect(assigns(:evaluation).instance_of?(Evaluation)).to be(true)
    end

    it "assigns @instructor" do
      i1 = FactoryGirl.create(:instructor)
      i2 = FactoryGirl.create(:instructor)
      FactoryGirl.create(:evaluation, instructor: i1)
      get :new
      expect(assigns(:instructors).count).to be(2) # number of instructors with evaluations + "New Instructor"
    end
  end

  describe "POST #create" do
    it "redirects to the evaluation index page upon evaluation creation" do
      eval = FactoryGirl.build(:evaluation, term: '2015C', enrollment: '25', item1_mean: '4.5')
      post :create, evaluation: eval.as_json
      expect(response).to redirect_to(evaluation_index_path(semester:'C', year:'2015'))
    end

    it "creates a new evaluation if parameters are valid" do
      eval = FactoryGirl.build(:evaluation, enrollment: '25', item1_mean: '4.5')
      expect(Evaluation.count).to eq(2)
      post :create, evaluation: eval.as_json
      expect(Evaluation.count).to eq(1)
    end

    it "creates a new instructor if necessary" do
      eval = FactoryGirl.build(:evaluation, instructor_id: 0, enrollment: '25', item1_mean: '4.5')
      previous_evaluation_count = Evaluation.count
      previous_instructor_count = Instructor.count
      post :create, evaluation: eval.as_json.merge(instructor: "Brent Walther")
      expect(Evaluation.count).to eq(previous_evaluation_count)
      expect(Instructor.count).to eq(previous_instructor_count + 1)
    end

    it "renders the new page again if params are invalid" do
      eval = FactoryGirl.build(:evaluation, term: "summer", enrollment: '25', item1_mean: '4.5')
      post :create, evaluation: eval.as_json
      expect(response).to render_template(:new)
    end

    it "renders the new page again if table items are out of range" do
      eval = FactoryGirl.build(:evaluation, item2_mean: 8, enrollment: '25', item1_mean: '4.5')
      post :create, evaluation: eval.as_json
      expect(response).to render_template(:new)
    end

    it "does not create an evaluation if table items are out of range" do
      eval = FactoryGirl.build(:evaluation, item2_mean: 8, enrollment: '25', item1_mean: '4.5')
      previous_evaluation_count = Evaluation.count
      post :create, evaluation: eval.as_json
      expect(Evaluation.count).to eq(previous_evaluation_count)
    end

    it "does not create an evaluation if parameters are invalid" do
      eval = FactoryGirl.build(:evaluation, term: "summer")
      previous_evaluation_count = Evaluation.count
      post :create, evaluation: eval.as_json
      expect(Evaluation.count).to eq(previous_evaluation_count)
    end
  end

  describe "GET #index" do
    it "redirects to the root path if no data exists" do
      get :index
      expect(response).to redirect_to(root_path)
    end

    it "redirects to the EvaluationController#show with the latest term if no params are given" do
      FactoryGirl.create(:evaluation, term: "2015C", enrollment: '25', item1_mean: '4.5')
      FactoryGirl.create(:evaluation, term: "2014C")
      get :index
      expect(response).to redirect_to(evaluation_path(id: "2015C"))
    end

    it "redirects to EvaluationController#show with the passed term parameter if present" do
      FactoryGirl.create(:evaluation, term: "2015C", enrollment: '25', item1_mean: '4.5')
      FactoryGirl.create(:evaluation, term: "2014C")
      get :index, year: "2014", semester: "C"
      expect(response).to redirect_to(evaluation_path(id: "2014C", year: "2014", semester: "C"))
    end
  end

  describe "GET #show" do
    it "assigns @evaluations" do
        eval1 = FactoryGirl.create(:evaluation, course: 110, term: '2015C', enrollment: '25', item1_mean: '4.5')
        eval2 = FactoryGirl.create(:evaluation, course: 111, term: '2015C', enrollment: '25', item1_mean: '4.5')
        eval3 = FactoryGirl.create(:evaluation, course: 111, term: '2014C')
        get :show, id: '2015C', year: "2015", semester: "C"
        expect(assigns(:evaluation_groups)).to eq([[eval1], [eval2]])
    end

    it "select correct evaluations" do
        ins1  = FactoryGirl.create(:instructor, id: 1, name: 'James Bond')
        ins2  = FactoryGirl.create(:instructor, id: 2, name: 'Bat Man')
        eval1 = FactoryGirl.create(:evaluation, course: 110, term: '2015C', instructor_id: 1, enrollment: '25', item1_mean: '4.5')
        eval2 = FactoryGirl.create(:evaluation, course: 110, term: '2015C', instructor_id: 2, enrollment: '25', item1_mean: '4.5')
        eval3 = FactoryGirl.create(:evaluation, course: 111, term: '2014C', instructor_id: 2)
        get :show, id: '2015C',year: "2015", semester: "C", course_name: 'CSCE 110', instructor_name: 'James Bond'
        expect(assigns(:evaluation_groups)).to eq([[eval1]])
    end

    it "assigns @terms" do
      eval1 = FactoryGirl.create(:evaluation, term: '2015C', enrollment: '25', item1_mean: '4.5')
      eval2 = FactoryGirl.create(:evaluation, term: '2015B')
      eval3 = FactoryGirl.create(:evaluation, term: '2015B')
      get :show, id: '2015C'
      expect(assigns(:terms)).to include(eval1.term)
      expect(assigns(:terms)).to include(eval2.term)
      expect(assigns(:terms).length).to be(2) # should only include unique terms!
    end

    it "sorts evaluations by a criteria correctly" do
      ins1  = FactoryGirl.create(:instructor, id: 1, name: 'James Bond')
      ins2  = FactoryGirl.create(:instructor, id: 2, name: 'Bat Man')
      eval1 = FactoryGirl.create(:evaluation, course: 111, term: '2015C', instructor_id: 1, enrollment: '25', item1_mean: '4.5')
      eval2 = FactoryGirl.create(:evaluation, course: 110, term: '2015C', instructor_id: 2, enrollment: '25', item1_mean: '4.5')
      eval3 = FactoryGirl.create(:evaluation, course: 112, term: '2014C', instructor_id: 2)

      get :show, id: '2015C', sort_by: 'course_'
      expect(assigns(:evaluation_groups).first.first.course.to_s).to eq('110')

      get :show, id: '2015C', sort_by: 'course_level'
      expect(assigns(:evaluation_groups).last.first.course.to_s).to eq('110')

      get :show, id: '2015C', sort_by: 'semester_'
      expect(assigns(:evaluation_groups).last.first.course.to_s).to eq('112')

    end

  end

  describe "GET #import" do
    it "renders the pretty centered form template" do
      get :import
      expect(response).to render_template 'layouts/centered_form'
    end
  end

  describe "GET #export" do
    before :each do
      instructor = FactoryGirl.create(:instructor)
      FactoryGirl.create(:evaluation, term: '2015B', subject: 'CSCE', course: '110',  section: '501', responses: '20', enrollment: '25', item1_mean: '4.5', instructor_id: instructor.id)
      FactoryGirl.create(:evaluation, term: '2015C', subject: 'CSCE', course: '121',  section: '502', responses: '20', enrollment: '25', item1_mean: '4.5', instructor_id: instructor.id)
      FactoryGirl.create(:evaluation, term: '2015C', subject: 'CSCE', course: '131',  section: '501', responses: '20', enrollment: '25', item1_mean: '4.5', instructor_id: instructor.id)
      FactoryGirl.create(:course_name, subject_course: 'CSCE 110', name: 'Introduction to Algorithms')
      FactoryGirl.create(:course_name, subject_course: 'CSCE 121', name: 'Advanced Programming')
      FactoryGirl.create(:course_name, subject_course: 'CSCE 131', name: 'Data Structures')
    end

    it "generates a valid CSV file" do
      get :export, id: '2015C'
      expect { CSV.parse(response.body) }.to_not raise_error

      get :export, id: '2015C', course_name: 'Data Structures'
      expect { CSV.parse(response.body) }.to_not raise_error

    end

    it "only exports records for the term selected" do
      get :export, id: '2015C'
      csv = CSV.parse(response.body)
      expect(csv.size).to eq(16) 
    end

    it "exports an empty row after each group" do
      get :export, id: '2015C'
      csv = CSV.parse(response.body)
      row5 = csv[9]
      row5.each { |val| expect(val).to eq("") }
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      FactoryGirl.create(:evaluation)
      get :edit, id: 1
      expect(response).to render_template("evaluation/edit")
    end
  end

  describe "DELETE #destroy" do
    it "deletes the evaluation" do
      eval = FactoryGirl.create(:evaluation)
      delete :destroy, id: eval.id
      expect(Evaluation.count).to eq(2)
      expect(response).to redirect_to(evaluation_index_path)
    end
  end

  describe "GET #missing_data" do
    it "shows the evaluation data for the courses with missing data" do
      FactoryGirl.create(:evaluation, course: 210)
      FactoryGirl.create(:evaluation, course: 110, enrollment: '')
      get :missing_data
      expect(response).to render_template("evaluation/missing_data")
      expect(assigns(:evaluation_groups).count).to be(1)
    end
  end

  describe "PUT #update" do
    before :each do
      @eval1 = FactoryGirl.create(:evaluation, enrollment: 47, item1_mean: 3.56)
      @eval2 = FactoryGirl.create(:evaluation, enrollment: 22)
    end

    it "updates the enrollment and redirects to evaluation page  " do
      put :update, id: @eval1, :evaluation=>{:enrollment=>"44"}
      @eval1.reload
      expect(@eval1.enrollment).to eq (47)
      expect(response).to redirect_to("/evaluation/show?semester=#{@eval1.term[4]}&year=#{@eval1.term[0..3]}")
    end


    it "edits the correct row and redirects to evaluation page" do
      put :update, id: @eval1, :evaluation=>{:enrollment=>"54"}
      @eval1.reload
      @eval2.reload
      expect(@eval1.enrollment).to eq (47)
      expect(@eval2.enrollment).to eq (22)
      expect(response).to redirect_to("/evaluation/show?semester=#{@eval1.term[4]}&year=#{@eval1.term[0..3]}")
    end

    it "rejects and redirects back to edit for bad updates" do
      put :update, id: @eval1, evaluation: { enrollment: "45.5" }
      @eval1.reload
      expect(@eval1.enrollment).to eq(47)
      expect(response).to render_template("evaluation/edit")
    end

    it "rejects and redirects back to edit for out of range table items" do
      put :update, id: @eval1, evaluation: { item1_mean: 8}
      @eval1.reload
      expect(@eval1.item1_mean).to eq(3.56)
      expect(response).to render_template("evaluation/edit")
    end
  end

  describe "POST #upload" do
    it "fails gracefully for non excel files" do
      @file = fixture_file_upload('/random.dat', 'application/octet-stream')
      post :upload, data_file: @file
      expect(response).to redirect_to("/evaluation/import")
      expect(flash[:errors]).to_not be(nil)
    end

    it "gracefully rejects malformatted excel files" do
      @file = fixture_file_upload('/StatisticsReport_withoutCourseColumn.xlsx', 'application/vnd.ms-excel')
      post :upload, data_file: @file
      expect(response).to redirect_to("/evaluation/import")
      expect(flash[:errors]).to_not be(nil)
    end

    it "gracefully fails when no file is specified" do
      post :upload
      expect(response).to redirect_to("/evaluation/import")
      expect(flash[:errors]).to_not be(nil)
    end

    it "accepts .xlsx files for uploading" do
      @file = fixture_file_upload('/StatisticsReport.xlsx', 'application/vnd.ms-excel')
      post :upload, data_file: @file
      expect(response).to redirect_to("/evaluation/show")
    end

    it "accepts .xls files for uploading" do
      @file = fixture_file_upload('/OldStatsReport.xls', 'application/vnd.ms-excel')
      post :upload, data_file: @file
      expect(response).to redirect_to("/evaluation/show")
    end

    it "creates evaluation records for data the xlsx test file" do
      @file = fixture_file_upload('/StatisticsReport.xlsx', 'application/vnd.ms-excel')
      expect(Evaluation.count).to eq(2)
      post :upload, data_file: @file
      expect(Evaluation.count).to eq(9)
    end

    it "creates instructor records for data the xls test file" do
      @file = fixture_file_upload('/OldStatsReport.xls', 'application/vnd.ms-excel')
      expect(Instructor.count).to eq(2)
      post :upload, data_file: @file
      expect(Instructor.count).to eq(3)
    end

    it "creates the correct evaluation records for the xlsx test data" do
      @file = fixture_file_upload('/StatisticsReport.xlsx', 'application/vnd.ms-excel')
      expect(Evaluation.count).to eq(2)
      post :upload, data_file: @file
      expect(Evaluation.where(term: '2015C').count).to eq(9)
      expect(Evaluation.where(subject: 'CSCE').count).to eq(9)
      expect(Evaluation.where(course: '131').count).to eq(6)

      instructor_brent = Instructor.where(name: Instructor.normalize_name('Brent Walther')).first
      expect(Evaluation.where(instructor_id: instructor_brent).count).to eq(3)
    end
  end

  describe "GET #import_gpr" do
    it "renders the pretty centered form template" do
      get :import_gpr
      expect(response).to render_template 'layouts/centered_form'
    end
  end

  describe "POST #upload_gpr" do
    it "fails gracefully for non .pdf fils" do
      @file = fixture_file_upload('/random.dat', 'application/octet-stream')
      post :upload_gpr, data_file: @file, term: '2015C'
      expect(response).to redirect_to(import_gpr_evaluation_index_path)
      expect(flash[:errors]).to_not be(nil)
    end

    it "fails gracefully if term is missing" do
      @file = fixture_file_upload('/grade_distribution.pdf', 'application/pdf')
      post :upload_gpr, data_file: @file
      expect(response).to redirect_to(import_gpr_evaluation_index_path)
      expect(flash[:errors]).to_not be(nil)
    end

    it "fails gracefully if file is missing" do

      post :upload_gpr
      expect(response).to redirect_to(import_gpr_evaluation_index_path)
      expect(flash[:errors]).to_not be(nil)
    end

    it "accepts .pdf files for uploading" do
      @file = fixture_file_upload('/grade_distribution.pdf', 'application/pdf')
      post :upload_gpr, data_file: @file, term: '2015C'
      expect(response).to redirect_to("/evaluation/show")
    end

    it "doesn't leave any data blank" do
      @file = fixture_file_upload('/grade_dist_with_desilva.pdf', 'application/pdf')
      post :upload_gpr, data_file: @file, term: '2015C'
      Evaluation.all.each do |eval|
        expect(eval.instructor).to_not be(nil)
        expect(eval.gpr).to_not be(nil)
      end
    end
  end


end
