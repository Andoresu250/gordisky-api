class Payment < ApplicationRecord
	include AASM
	
	belongs_to :loan
	has_one :person ,through: :loan

	validates :number, presence: true

	before_create :complete_data

	aasm(:state) do
        state :pendiente, initial: true
		state :vencido
		state :pagado
		state :pagado_parcialmente
    
        event  :pagado do
            transitions  from: :pendiente, to: :pagado
		end
        
        event  :vencido do
            transitions  from: :pendiente, to: :vencido
		end
		
		event  :pago_parcial do
            transitions  from: :pendiente, to: :pagado_parcialmente
        end
    end

	def complete_data
		if self.loan.present?
			self.value = self.loan.fee_value
			self.date = self.loan.created_at + ( self.number * self.loan.frequency ).days if self.number.present?
		end
	end 

end
