When(/^User visits the add evaluation page$/) do
  visit '/evaluation/new'
end

Then(/^User be on the add evaluation page$/) do
  current_path.should == '/evaluation/new'
end

Then(/^User should be in evaluation page$/) do
  current_path.should == '/evaluation/show'
end
 