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
  #check(value)
  #find(value, :visible => false).click
  #find(:css, "#instructor_ids[][value='#{value}']").set(true)
  find("input[type='checkbox'][value='#{value}']").set(true)
end

Given(/^There exists (\d+) instructor in the database$/) do |n|
    prng = Random.new
  
    (1..n.to_i).each do |i|
        name = 'test' + i.to_s
        instructor = Instructor.create(name: name)
    end
  end