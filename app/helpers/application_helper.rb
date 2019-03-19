module ApplicationHelper
  def compute_total_responses(group)
    group.map(&:responses).inject(:+)
  end 
  
  def compute_total_enrollment(group)
    group.map(&:enrollment).inject(:+)
  end

  def compute_weighted_average_for_item(x, group)
    group.inject(0) { |sum, eval| sum += eval.enrollment * eval.send("item#{x}_mean".to_sym) } / compute_total_enrollment(group)
  end

  def compute_mean_student_eval_score(group)
    if group.last[:history] == 1
      result = group[0][:mses]
      return result
    else
      return (1..8).inject(0) { |sum, x| sum += compute_weighted_average_for_item(x, group) } / 8
    end  
  end

  def compute_weighted_average_for_item2(x, group)
   group.inject(0) { |sum, eval| sum += eval.enrollment * eval.send("item#{x}_mean".to_sym) } / compute_total_enrollment(group)
  end

  def compute_course_level_average(group, groups)
    if group.last[:history] == 1
      result = group[0][:dae]
      return result
    else
      groups = groups.reject do |g|
        g.first.course.to_s[0] != group.first.course.to_s[0] || g.first.term != group.first.term
      end
      .map { |g| compute_mean_student_eval_score(g) }
      @test = groups[0]
      Rails.logger.info "test for #{@test.inspect}"
      len = groups.size
      nonnil = groups.compact
      return nonnil.reduce(:+) / len
    end
  end

  def compute_mean_gpr(group)
    if group.last[:history] == 1
      result = group[0][:ang]
        if is_number?(result)
          return result.to_f.round(2)
        else
          return result
        end
    else
      gprs = group.map(&:gpr)
      return nil if gprs.any?(&:nil?)
      x = gprs.inject(:+) / gprs.size
      y = x.round(2)
      return y
    end
  end

  def compute_course_level_mean_gpr(group, groups)
    if group.last[:history] == 1
      result = group[0][:dang]
      return result
    else
      groups = groups.reject do |g|
        g.first.course.to_s[0] != group.first.course.to_s[0] || g.first.term != group.first.term
      end
      .map { |g| compute_mean_gpr(g) }
      .reject(&:nil?)
  
      return nil if groups.size == 0
      return groups.reduce(:+) / groups.size
    end
  end
  
  def is_number? string
    true if Float(string) rescue false
  end
end
