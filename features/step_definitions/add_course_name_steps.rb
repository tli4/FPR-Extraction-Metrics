Then(/^User be on the instructor evaluation page for (.+)$/) do |inst_name|
  inst = Instructor.where(name: Instructor.normalize_name(inst_name)).first
  current_path.should == "/instructor/#{inst.id}"
end

Then(/^User visits the instructor evaluation page for (.+)$/) do |inst_name|
  inst = Instructor.where(name: Instructor.normalize_name(inst_name)).first
  visit "/instructor/#{inst.id}"
end


