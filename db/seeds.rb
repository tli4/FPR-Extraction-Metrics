# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

prng = Random.new

instructor = Instructor.create(name: 'Tiffani Williams')
course = CourseName.create(subject_course: 'CSCE 110')
(1..3).each do |i|
  Evaluation.create(
    term: '2014C',
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
    item8_mean: prng.rand(3.0..5.0).round(2),
    gpr: prng.rand(3.0..5.0).round(2),
  )
end

instructor = Instructor.create(name: 'Joseph Daniel Hurley')
course = CourseName.create(subject_course: 'CSCE 111')
(1..3).each do |i|
  Evaluation.create(
    term: '2015C',
    subject: 'CSCE',
    course: '111',
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
    item8_mean: prng.rand(3.0..5.0).round(2),
    gpr: prng.rand(3.0..5.0).round(2),
  )
end

(1..3).each do |i|
  Evaluation.create(
    term: '2014C',
    subject: 'CSCE',
    course: '111',
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
    item8_mean: prng.rand(3.0..5.0).round(2),
    gpr: prng.rand(3.0..5.0).round(2),
  )
end

course = CourseName.create(subject_course: 'CSCE 206')
(1..3).each do |i|
  Evaluation.create(
    term: '2015C',
    subject: 'CSCE',
    course: '206',
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
    item8_mean: prng.rand(3.0..5.0).round(2),
    gpr: prng.rand(3.0..5.0).round(2),
  )
end


instructor = Instructor.create(name: 'Walter Daugherity')
course = CourseName.create(subject_course: 'CSCE 121')
(1..8).each do |i|
  Evaluation.create(
    term: '2015B',
    subject: 'CSCE',
    course: '121',
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
    item8_mean: prng.rand(3.0..5.0).round(2),
    gpr: prng.rand(3.0..5.0).round(2),
  )
end
