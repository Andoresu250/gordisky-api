class PaymentSerializer < ApplicationSerializer
  attributes :number, :date, :paid_at, :value, :paid_value, :state
  has_one :loan
end
