module ActiveRecord::AttributeAssignmentOverride
    def assign_attributes(new_attributes, options={})  
      override = options[:override].nil? ? true : options[:override]
      return super(new_attributes) unless override    
      new_attributes.keys.each do |key|
        new_attributes[key] = Object.const_get(key[0..-3].classify).decode_id(new_attributes[key]) if key.to_s.end_with? "_id"
      end
      super(new_attributes.select {|k,_| self[k].nil? })
    end
end