class LoanSerializer < ApplicationSerializer
  attributes :amount, :interest, :debt, :fees, :fees_fulfilled, :remaining_fees, :frequency, :paid, :last_paid, :next_paid, :fee_value, :missed_payments
  has_one :person
  has_one :company
  has_many :payments  do
    if object.payments.first != nil && object.payments.first.id == nil
      object.payments
    else
      object.payments.order(:number)
    end
  end 
  
  def missed_payments
    object.count_missed_payments
  end
  
end
