class CourseNameImportUtils
  class << self

    def import(hashes)
      hashes.map do |attributes|
        import_operator(attributes)
      end
    end

    def import_operator(attributes)
      _, is_new = CourseName.create_if_needed_and_update(attributes)
      { status: is_new }
    end
  end
end
