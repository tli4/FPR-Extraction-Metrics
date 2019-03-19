FactoryGirl.define do
  factory :evaluation do
    term '2015C'
    subject 'CSCE'
    course '121'
    section '501'
    association :instructor, factory: :instructor
    responses '50'
    enrollment '50'
    item1_mean '4.32'
    item2_mean '4.32'
    item3_mean '4.32'
    item4_mean '4.32'
    item5_mean '4.32'
    item6_mean '4.32'
    item7_mean '4.32'
    item8_mean '4.32'
    gpr '3.5'
  end
end
