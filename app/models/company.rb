class Company < ApplicationRecord

    has_one :user, as: :profile
    has_many :monetary_transactions
    has_many :loans
    has_many :payments, through: :loans
    
    validates :name, presence: true
    validates :name, :nit, :phone, :address, uniqueness: true, allow_blank: true

    def full_name
        self.name
    end
    
end
