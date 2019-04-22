class PaymentSerializer < ApplicationSerializer
  attributes :number, :date, :paid_at, :value, :paid_value, :state, :is_missed
  has_one :loan
  
  def is_missed
    object.is_missed
  end
end
