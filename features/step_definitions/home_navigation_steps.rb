Then(/^User should see the evaluations page for (.+)$/) do |page|
  current_path.should == "/evaluation/#{page}"
end

Then(/^User should see the faculty member historical data page$/) do
  current_path.should == '/instructor'
end
