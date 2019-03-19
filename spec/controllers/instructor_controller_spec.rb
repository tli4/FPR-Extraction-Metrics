require 'rails_helper'

RSpec.describe InstructorController, type: :controller do

  it "redirects the user to the login page if they are unauthenticated" do
    sign_out @user
    get :index
    expect(response).to redirect_to(new_user_session_path)
  end

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end


    it "renders the evaluation index" do
      get :index
      expect(response).to render_template("instructor/index")
    end


    it "assigns @instructors" do
        instr = FactoryGirl.create(:instructor)
        FactoryGirl.create(:evaluation, instructor_id: instr.id)
        get :index
        expect(assigns(:instructors)).to eq([instr])
    end

    it "@instructors is in sorted order by last name" do
        hurley = Instructor.create(name: "Joseph Daniel Hurley")
        daugherity = Instructor.create(name: "Walter Daugherity")
        williams = Instructor.create(name: "Tiffani Williams")
        FactoryGirl.create(:evaluation, instructor_id: hurley.id)
        FactoryGirl.create(:evaluation, instructor_id: daugherity.id)
        FactoryGirl.create(:evaluation, instructor_id: williams.id)
        get :index
        expect(assigns(:instructors)).to eq([daugherity,hurley,williams])
    end
  end

  describe "GET #show" do
    let (:inst) { Instructor.create(name: 'Brent Walther') }

    it "responds successfully" do
      get :show, { id: inst.id }
      expect(response).to be_success
    end

    it "assigns @instructor" do
      get :show, { id: inst.id }
      expect(assigns(:instructor)).to eq(inst)
    end

    it "assigns the instructors course groups in term descending order" do
      first = FactoryGirl.create(:evaluation, instructor: inst, term: '2015C')
      second = FactoryGirl.create(:evaluation, instructor: inst, term: '2015B')
      third = FactoryGirl.create(:evaluation, instructor: inst, term: '2010A')

      get :show, { id: inst.id }
      expect(assigns(:instructor_course_groups)).to eq([[first], [second], [third]])
    end
  end

  describe "GET #export" do
    before :each do
      instructor = FactoryGirl.create(:instructor, name: 'Bob')
      FactoryGirl.create(:evaluation, subject: 'CSCE', course: '123', term: '2015C', section: '501', responses: '20', enrollment: '25', item1_mean: '4.5', instructor_id: instructor.id)
      FactoryGirl.create(:evaluation, subject: 'CSCE', course: '123', term: '2015C', section: '502', responses: '20', enrollment: '25', item1_mean: '4.5', instructor_id: instructor.id)
      FactoryGirl.create(:evaluation, subject: 'CSCE', course: '123', term: '2015B', section: '501', responses: '20', enrollment: '25', item1_mean: '4.5', instructor_id: instructor.id)
      FactoryGirl.create(:evaluation, subject: 'CSCE', course: '681', term: '2015C', section: '201', responses: '20', enrollment: '25', item1_mean: '4.5', instructor_id: instructor.id)
      FactoryGirl.create(:course_name, subject_course: 'CSCE 681', name: "Advanced Compiler")
    end

    it "generates a valid CSV file" do
      get :export, id: 1
      expect { CSV.parse(response.body) }.to_not raise_error
    end
    
    #testing: check if total number of responses were exported in csv from
    # instructor page
    it "correctly totals the students for all sections" do
      get :export, id: 1
      csv = CSV.parse(response.body)
      expect(csv[3][2]).to eq("40")
    end

    it "correctly totals the students for all sections" do
      get :export, id: 1
      csv = CSV.parse(response.body)
      expect(csv[3][3]).to eq("50")
    end
    
    it "has a separate entry for the same course in different terms" do
      get :export, id: 1
      csv = CSV.parse(response.body)
      expect(csv.size).to eq(6) # total enrollment
    end

    it "assigns the instructors course groups in term descending order" do
      get :export, id: 1
      csv = CSV.parse(response.body)
      expect(csv[3][1]).to eq("FA15")
      expect(csv[5][1]).to eq("SU15")
    end
  end
end
