Then(/^User should be on the admin pages$/) do
  current_path.should == '/admin'
end

Given(/^User changes (.+) user to (.+)$/) do |currentRole, newRole|
  click_link(currentRole.downcase+'@man.net'+newRole)
end

Then(/^(.+) user should now have role (.+)$/) do |currentRole, newRole|
  User.where(email: currentRole.downcase+'@man.net').take.has_role? newRole.to_sym
end

Then(/^There should be at least (\d+) (.+)$/) do |num, role|
  expect User.with_role(role.to_sym).length >= num.to_i
end

#Then(/^User should see message stating Minimum of (\d+) (.+)$/) do |num, role|
#  expect User.with_role(role.to_sym).length >= num.to_i
#end

When(/^User visits user management panel page$/) do
  visit '/admin'
end
