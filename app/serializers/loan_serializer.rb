class LoanSerializer < ApplicationSerializer
  attributes :amount, :interest, :debt, :fees, :fees_fulfilled, :remaining_fees, :frequency, :paid, :last_paid, :next_paid, :fee_value
  has_one :person
  has_one :company
  has_many :payments
end
