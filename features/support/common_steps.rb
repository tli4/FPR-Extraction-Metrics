Given(/^User is authenticated$/)do
  email = 'testing@man.net'
  password = 'secretpass'
  User.new(:email => email, :password => password, :password_confirmation => password).save!

  visit '/users/sign_in'
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "Log in"
end

Given(/^There exists 4 users assigned admin, readWrite, readOnly, and guest as roles$/) do
  Role.new.readable_roles.each do |key, value|
    user = User.new(:email => key.to_s+"@man.net", :password => 'secretpass', :password_confirmation => 'secretpass')
    user.add_role key
    user.save!
  end
end

Given(/^User is of class (.+)$/) do |userClass|
  visit '/users/sign_in'
  fill_in "user_email", :with => userClass+"@man.net"
  fill_in "user_password", :with => 'secretpass'
  click_button "Log in"
end

Given(/^User has uploaded PICA data$/) do
  visit '/evaluation/import'
  page.attach_file("data_file", Rails.root + 'spec/fixtures/StatisticsReport.xlsx')
  click_on("Upload")
  click_on("Home")
end

Given(/^User has uploaded Historical data$/) do
  visit '/evaluation/import_history'
  page.attach_file("data_file", Rails.root + 'spec/fixtures/HistoricalReport.xlsx')
  click_on("Upload")
  click_on("Home")
end

Given(/^User has uploaded matching PICA data$/) do
  visit '/evaluation/import'
  page.attach_file("data_file", Rails.root + 'spec/fixtures/StatisticsReport_actual_profs.xlsx')
  click_on("Upload")
  click_on("Home")
end

Given(/^User is on the home page/i) do
  visit '/'
end

When(/^User clicks on the (.+) button$/) do |buttonName|
  click_on(buttonName)
end

When(/^User clicks on (.+) link$/) do |button|
  click_link(button, match: :first)
end

When(/^User fills in ([A-Za-z0-9 ,.@]+)$/) do |fill_ins|
  fill_ins.split(",").each do |fill_in|
    field_name, value = fill_in.strip.split(" with ")
    fill_in(field_name, :with => value)
  end
end

When(/^User selects (.+) from the (.+) select menu$/) do |value, select_name|
  select value, :from => select_name
end

Then(/^User should see input fields for ([A-Za-z0-9 ,]+)$/) do |fields|
  fields.split(",").each do |field|
    field = field.strip
    page.should have_field(field)
  end
end

Then(/^User should see a table of (\d+) data rows$/) do |n|
  expect(page).to have_css("tbody > tr", count: n.to_i)
end

Then(/^User should not see the (.+) (link|button)$/) do |name, selector|
  page.should_not have_selector(:link_or_button, name)
end

Then(/^User should see the (.+) (link|button)$/) do |name, selector|
  page.should have_selector(:link_or_button, name)
end

Then(/^User should be on the home page$/) do
  current_path.should == "/"
end

Then(/^User should see (.+) as text$/) do |text|
  page.should have_content(text)
end

Then(/^User should not see (.+) as text$/) do |text|
  page.should_not have_content(text)
end

Then(/^User should see ([0-9]+) new evaluations imported. ([0-9]+) evaluations updated.$/) do |numNew, numUpdate|
  expect(page).to have_content("#{numNew} new evaluations imported. #{numUpdate} evaluations updated.")
end

When(/^User selects a non-excel file$/) do
  page.attach_file("data_file", Rails.root + 'spec/fixtures/ruby-capybara.zip')
end

Then(/^User should see message stating (.+)$/) do |message|
  expect(page).to have_content(message)
end

When(/^User selects excel file$/) do
  page.attach_file("data_file", Rails.root + 'spec/fixtures/HistoricalReport.xlsx')
end