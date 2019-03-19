Given(/^User is on the import page$/) do
  visit '/evaluation/import'
end

Then(/^User should be on the import page$/) do
  current_path.should == "/evaluation/import"
end

When(/^User selects evaluation excel file$/) do
  page.attach_file("data_file", Rails.root + 'spec/fixtures/StatisticsReport.xlsx')
end
