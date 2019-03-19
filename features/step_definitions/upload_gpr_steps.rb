Then(/^User should be on the import GPR page$/) do
    current_path.should == '/evaluation/import_gpr'
end

Given(/^User is on the import GPR page$/) do
  visit '/evaluation/import_gpr'
end

When(/^User selects GPR file$/) do
  page.attach_file("data_file", Rails.root + 'spec/fixtures/grade_distribution.pdf')
end

Then(/^User should see ([0-9]+) new GPRs imported. ([0-9]+) evaluation GPRs updated.$/) do |numNew, numUpdate|
  expect(page).to have_content("#{numNew} new GPRs imported. #{numUpdate} evaluation GPRs updated.")
end

Then(/^User should only see instructors who were in the PICA data$/) do
  page.should have_no_content("Williams, T ")
  page.should have_no_content("Hurley, J ")
  page.should have_content("B, Gooch ")
  page.should have_no_content("Welch, J ")
  page.should have_content("W, Daugherity ")
  page.should have_content("Walther, Brent ")
  page.should have_no_content("Scott, Deaton ")
end

Then(/^User should only see instructors who were in the GPR data$/) do
  page.should have_no_content("Tiffani Williams")
  page.should have_content("Hurley J")
  page.should have_content("Welch, Jennifer ")
  page.should have_content("Daugherity W")
  page.should have_content("B, Gooch ")
end

Then(/^User should see a GPR of ([0-4]\.[0-9]+)$/) do |gpr|
  page.should have_content(gpr)
end
