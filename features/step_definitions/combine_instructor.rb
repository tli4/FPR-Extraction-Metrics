Then(/^User should be on the instructor list page$/) do
    current_path.should == '/instructor'
end

Then(/^User should be on the Combine instructors page$/) do
    current_path.should == '/instructor/combine'
end

Then(/^User should be on the confirm combine page$/) do
    current_path.should == '/instructor/merge_confirm'
end

When(/^User selects (.+) from the instructor list$/) do |value|
  check(value)
end