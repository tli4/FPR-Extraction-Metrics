When(/^User directly visits (.+)$/) do |address|
  visit address
end

Then(/^User should be on page with path of (.+)$/) do |path|
    current_path.should == path
end