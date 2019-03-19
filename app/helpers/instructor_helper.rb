module InstructorHelper

  def course_name_for(group)
    course = group.first;
    name = course.subject_course;
    if (course.section.to_s.starts_with?("2"))
      name = name + "H"
    end
    if group.last[:history] == 1
      coursename = group[0][:coursestring]
      len = coursename.length
      if len == 4
        name = name + coursename[3]
      end
    end
    return name
  end

  def put_last_name(name)
    last_name = name.split(" ").last
    first_name = name.split(" ")
    first_name.delete(first_name.last)
    first_name.join(" ")
    first_name.to_s
    full_name = last_name + ", "
    for words in first_name
        full_name = full_name + words + " "
    end   
    return full_name
  end
  
  def inst_list(status)
    inst = Instructor.order(:name).where(status)
    inst = inst.sort { |a, b| a.name.split(" ").last <=> b.name.split(" ").last }
    return inst
  end
   
  def term_format(term)
    year = term[0..3]
    semester = term[4] 
    if semester == "A"
      t = "SP"+ year[2..3]
    elsif semester == "B"
      t = "SU" + year[2..3]
    elsif semester == "C"
      t = "FA" + year[2..3]
    end
    return t
  end

  def get_complete_name(group)
    if group.last[:history] == 1
      coursename = group[0][:coursestring]
      coursesubject = group[0][:subject]
      complete_name = coursesubject + " " + coursename
      
    else
      course = group.first
      complete_name = course.subject_course;
      if (course.section.to_s.starts_with?("2"))
        complete_name = complete_name + "H"
      end
  
      name = CourseName.where(subject_course: course.subject_course).first.try(:name)
      if (!name.nil?)
        complete_name = complete_name + " " + name
      end
    end
    return complete_name
  end

  def is_honors(course_section)
    pos_fix = ""
    if (course_section.to_s.starts_with?("2"))
      pos_fix = "H"
    end
    return pos_fix
  end

end
