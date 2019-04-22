class Loan < ApplicationRecord

    belongs_to :person, optional: true
    belongs_to :company
    has_many :payments, dependent: :destroy

    validates :amount, :interest, :debt, :fees, :fees_fulfilled, :remaining_fees, :frequency, :paid, :next_paid, :fee_value, :company_id, presence: true
    
    validates :amount, :interest, :debt, :fees, :fees_fulfilled, :remaining_fees, :frequency, :paid, :fee_value, numericality: {greater_than_or_equal_to: 0}
    
    validates :interest, numericality: {greater_than: 0, less_than: 1}
    
    validates :fees, :fees_fulfilled, :remaining_fees, :frequency, numericality: { only_integer: true }
    
    validates :person, presence: true, on: [:create, :update]

    after_create :create_payments
    
    scope :by_first_names,           -> (name) { joins(:person).where("LOWER(people.first_names) @@ ?", "#{name}".downcase) }
    scope :by_last_names,            -> (name) { joins(:person).where("LOWER(people.last_names) @@ ?", "#{name}".downcase) }
    scope :by_full_name,             -> (name) { joins(:person).where("LOWER(CONCAT(people.first_names, ' ', people.last_names)) @@ ?", "#{name}".downcase) }
    scope :by_identification,        -> (number) { joins(:person).where("LOWER(people.identification) LIKE ?", "%#{number}%".downcase) }    
    scope :by_phone,                 -> (phone) { joins(:person).where("people.phone LIKE ?", phone ) }
    scope :by_person_id,             -> (person_id) {joins(:person).where(people: {id: Person.decode_id(person_id)})}

    def self.filters
        [:by_first_names, :by_last_names, :by_full_name, :by_identification, :by_phone, :by_person_id]
    end
    
    def self.filter_cases
        cases = []
        return cases
    end

    def self.exclude_filters_for_search
        []
    end
    
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
            unless payment.save
            puts payment.errors.full_messages
            end
        end
    end
    
    def set_fake_payments
        self.payments = []
        return nil if self.fees.nil?
        (1..self.fees).each do |index|
            payment = Payment.new(loan: self, number: index)
            payment.complete_data_fake
            self.payments << payment
        end
    end
    
    def count_missed_payments
        self.payments.misseds.count
    end
    
    def refresh_paids
        self.paid = self.payments.sum(:paid_value)
        self.fees_fulfilled = self.payments.paids.count
        self.remaining_fees = self.fees - self.fees_fulfilled
        self.last_paid = DateTime.now
    end
    
    

end
