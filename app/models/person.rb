class Person < ApplicationRecord

    validates :first_names, :last_names, :identification, presence: true
    validates :identification, uniqueness: true

    scope :by_first_names,            -> (name) { where("LOWER(people.first_names) LIKE ?", "%#{name}%".downcase) }
    scope :by_last_names,             -> (name) { where("LOWER(people.last_names) LIKE ?", "%#{name}%".downcase) }
    scope :by_full_name,             -> (name) { where("LOWER(CONCAT(people.first_names, ' ', people.last_names)) @@ ?", "#{name}".downcase) }
    scope :by_identification,        -> (number) { where("LOWER(people.identification) LIKE ?", "%#{number}%".downcase) }    
    scope :by_phone,                 -> (phone) { where("people.phone LIKE ?", phone ) }

    def self.filters
        [:by_first_names, :by_last_names, :by_full_name, :by_identification, :by_phone]
    end
    
    def self.filter_cases
        cases = []
        return cases
    end

    def self.exclude_filters_for_search
        []
    end

    def full_name
        "#{self.first_names} #{self.last_names}"
    end

end
