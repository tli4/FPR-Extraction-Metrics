class EvaluationImportUtils
  class << self

    def import(hashes)
      hashes.map do |attributes|
        key_attrs, other_attrs = split_attributes(attributes)
        import_if_csce_eval(key_attrs, other_attrs)
      end
    end

    def import_if_csce_eval(key_attrs, other_attrs)
      case key_attrs[:subject]
      when 'CSCE'
        _, is_new = Evaluation.create_if_needed_and_update(key_attrs, other_attrs)
        { status: is_new }
      when 'ENGR'
        # This will only add professors it has already seen before
        inst = Instructor.where(name: Instructor.normalize_name(other_attrs[:instructor])).first
        if inst
          _, is_new = Evaluation.create_if_needed_and_update(key_attrs, other_attrs)
          { status: is_new }
        else
          { status: :failure }
        end
      else
        { status: :failure }
      end
    end

    def split_attributes(all_attrs)
        # key attributes are ones for which we should have one unique record for a set of them
        key_attributes = all_attrs.select { |k,v| Evaluation.key_attributes.include?(k.to_sym) }

        # other atttributes are ones that should either be assigned or updated
        other_attributes = all_attrs.reject { |k,v| Evaluation.key_attributes.include?(k.to_sym) }

        [ key_attributes, other_attributes ]
    end
  end
end
