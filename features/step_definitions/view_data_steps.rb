Given(/^There exists (\d+) groups? of (\d+) evaluation records in the database for instructor (.+)$/) do |n_groups, n_records, name|
  prng = Random.new

  instructor = Instructor.create(name: name)
  (1..n_groups.to_i).each do |g|
    (1..n_records.to_i).each do |i|
      Evaluation.create(
        term: '2015C',
        subject: 'CSCE',
        course: (110 + g).to_s,
        section: (500 + i).to_s,
        instructor: instructor,
        responses: prng.rand(1..20),
        enrollment: prng.rand(20..50),
        item1_mean: prng.rand(3.0..5.0).round(2),
        item2_mean: prng.rand(3.0..5.0).round(2),
        item3_mean: prng.rand(3.0..5.0).round(2),
        item4_mean: prng.rand(3.0..5.0).round(2),
        item5_mean: prng.rand(3.0..5.0).round(2),
        item6_mean: prng.rand(3.0..5.0).round(2),
        item7_mean: prng.rand(3.0..5.0).round(2),
        item8_mean: prng.rand(3.0..5.0).round(2)
      )
    end
  end
end

When /^User selects "(.*)" from "(.*)"$/ do |value, field|
  select(value, :from => field)
end

When /^User clicks on button "(.*)"$/ do |value|
  click_button(value)
end

When(/^User visits the evaluation index page$/) do
  visit '/evaluation'
end

When(/^User visits the instructor index page$/) do
  visit '/instructor'
end


When(/^Clicks on header of (.+)$/) do |term_sort|
  click_link(term_sort)
end

When(/^Clicks on the name of instructor (.+)$/) do |name|
  click_link(name, match: :first)
end

When(/^User selects "([^"]*)" from "([^"]*)"$/) do |value, field|
  select(value, :from => field) 
end

When(/^User clicks on (.+)? button on evaluation index page$/) do |button|
  click_on(button)
end

When(/^User clicks on term (.+)$/) do |name|
  click_link(name, match: :first)
end

When(/^User clicks on course number (.+)$/) do |name|
  click_link(name, match: :first)
end

Then(/^User should see courses page for (.+)$/) do |name|
  expect(page).to have_content(name)
  expect(page).to have_css("tbody tr")
end

Then(/^User should see a link for instructor (.+)$/) do |name|
  expect(page).to have_link(name)
end

Then(/^User should see a link for term (.+)$/) do |name|
  expect(page).to have_link(name)
end

Then(/^User should see a link for course number (.+)$/) do |name|
  expect(page).to have_link(name)
end


Then(/^User should see an empty row between the (.+)? groups, given there are (.+)? evaluation records for each group$/) do |n_groups,n_records|
  (1..n_groups.to_i).each do |g|
    expect(page).to have_css("tr[#{g*(n_records.to_i+2)}] > td", count: 1)
  end
end

Then(/^User should see (.+)? empty cells in each sum and average row, given there are (.+)? groups and (.+)? evaluation records for each group$/) do |colspan,n_groups,n_records|
  (1..n_groups.to_i).each do |g|
    expect(page).to have_css("tr[#{g*(n_records.to_i+2)-1}] td[@colspan='#{colspan}']", count: 1, text: nil)
    expect(page).to have_css("tr[#{g*(n_records.to_i+2)-1}] td", count: 17)
  end

end
