Given(/^User is on the import history page$/) do
  visit '/evaluation/import_history'
end

Then(/^User should be on the import history page$/) do
  current_path.should == "/evaluation/import_history"
end

When(/^User selects historical excel file$/) do
  page.attach_file("data_file", Rails.root + 'spec/fixtures/HistoricalReport.xlsx')
end