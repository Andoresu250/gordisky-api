class Loan < ApplicationRecord

    belongs_to :person
    belongs_to :company
    has_many :payments, dependent: :destroy

    validates :amount, :interest, :debt, :fees, :fees_fulfilled, :remaining_fees, :frequency, :paid, :next_paid, :fee_value, :person_id, :company_id, presence: true

    after_create :create_payments
    
    def complete_data
        self.paid = 0
        self.fees_fulfilled = 0        
        if self.amount.present? && self.interest.present?
            self.debt = self.amount * (1 + self.interest)
            if self.fees.present?
                self.remaining_fees = self.fees
                self.fee_value = self.debt / self.fees
                self.next_paid = DateTime.now + self.frequency.days if self.frequency.present?
            end
        end
    end

    def create_payments
        (1..self.fees).each do |index|
            payment = Payment.new(loan: self, number: index)
            payment.save
        end
    end

end
