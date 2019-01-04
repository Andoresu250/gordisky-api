class Company < ApplicationRecord

    has_one :user, as: :profile
    
    validates :name, presence: true
    validates :name, :nit, :phone, :address, uniqueness: true, allow_blank: true

    def full_name
        self.name
    end
    
end
