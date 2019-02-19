class Person < ApplicationRecord

    validates :first_names, :last_names, :identification, presence: true
    validates :identification, uniqueness: true

    scope :by_first_name,            -> (name) { where("LOWER(people.first_name) LIKE ?", "%#{name}%".downcase) }
    scope :by_last_name,             -> (name) { where("LOWER(people.last_name) LIKE ?", "%#{name}%".downcase) }
    scope :by_identification,        -> (number) { where("LOWER(people.identification) LIKE ?", "%#{number}%".downcase) }    
    scope :by_phone,                 -> (phone) { where("people.phone_number LIKE ?", phone ) }

    def self.filters
        [:by_first_name, :by_last_name, :by_identification, :by_phone]
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
