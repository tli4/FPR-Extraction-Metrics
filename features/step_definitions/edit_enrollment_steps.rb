Given(/^There exists (\d+) evaluation record in the database for instructor (.+)$/) do |n, name|
  prng = Random.new

  instructor = Instructor.create(name: name)
  (1..n.to_i).each do |i|
    Evaluation.create(
      term: '2015C',
      subject: 'CSCE',
      course: '110',
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

When(/^User visits the evaluation page$/) do
  visit '/evaluation'
end

When(/^User is on edit page for user (.+)$/) do |n|
	visit '/evaluation/'+n+'/edit'
end
When(/^User clicks on (.+)? button on edit page$/) do |button|
  click_on(button)
end

Then(/^User should see a link for (.+) for the record$/) do |name|
  expect(page).to have_link(name)
end

Then(/^User should be redirected to evaluation edit page with (.+) button$/) do |button|
	expect(page).to have_button(button)
end

Then(/^User should be redirected to evaluation index page$/) do
	visit '/evaluation'
end
