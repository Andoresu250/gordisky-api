class Payment < ApplicationRecord
	
	include AASM
	
	belongs_to :loan
	has_one :person ,through: :loan
	has_one :company ,through: :loan
	
	scope :misseds,  -> { where('date < ?', DateTime.now).where('paid_value < value') }
	
	scope :unpaids, -> { where('paid_value < value').order('number asc') }
	
	scope :paids, -> { where(state: 'pagado') }

	validates :number, presence: true
	
	validates :value, :paid_value, numericality: {greater_than_or_equal_to: 0}
	
	validates :paid_value, numericality: { less_than_or_equal_to: :value }, unless: Proc.new { |a| a.paid_value.present? }

	before_validation :complete_data
	
	before_save :set_state

	aasm(:state) do
        state :pendiente, initial: true
		state :vencido
		state :pagado
		state :pagado_parcialmente
    
        event  :full_paid do
            transitions  from: [:pendiente, :pagado_parcialmente, :vencido], to: :pagado
		end
        
        event  :miss_paid do
            transitions  from: [:pendiente, :pagado_parcialmente, :vencido], to: :vencido
		end
		
		event  :partially_paid do
            transitions  from: [:pendiente, :vencido, :pagado_parcialmente], to: :pagado_parcialmente
        end
    end

	def complete_data
		unless self.id.nil?
			return
		end
		if self.loan.present?
			self.value = self.loan.fee_value
			dt = self.loan.created_at || DateTime.now
			self.date = dt + ( self.number * self.loan.frequency ).days if self.number.present?
		end
	end 
	
	def complete_data_fake
		if self.loan.present? && self.loan.frequency.present?
			self.value = self.loan.fee_value
			self.date = DateTime.now + ( self.number * self.loan.frequency ).days if self.number.present?
		end
	end
	
	def is_missed
		return self.date < DateTime.now && (self.paid_value.nil? || self.paid_value < self.value)
	end
	
	def pending_value
		return self.value - self.paid_value
	end
	
	def set_state
		return false if self.id.nil?
		if self.paid_value_changed? && self.paid_value > 0
			if self.paid_value < self.value
				self.partially_paid
			else
				self.full_paid
			end
		end
	end
	
	def pay(pay_value)
		self.paid_at = DateTime.now
		if pay_value <= self.pending_value
            self.paid_value += pay_value
            MonetaryTransaction.create_asset(self, pay_value)
            return 0
    	else
        	v = pay_value - self.pending_value
        	MonetaryTransaction.create_asset(self, self.pending_value)
        	self.paid_value = self.value
        	return v
    	end
	end

end
