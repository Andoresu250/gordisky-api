class MonetaryTransaction < ApplicationRecord
    
    belongs_to :company
    
    validates :mode, inclusion: { in: ["activo", "pasivo"]}, allow_nil: false
    validates :value, numericality: {greater_than: 0}
    validates :mode, :value, :description, presence: true
    
    def self.ACTIVO
        "activo"
    end
    
    def self.PASIVO
        "pasivo"
    end
    
    scope :assets, -> { where(mode: MonetaryTransaction.ACTIVO) }
    scope :liabilities, -> { where(mode: MonetaryTransaction.PASIVO) }
    scope :by_mode, -> (mode){ where(mode: mode) }
    
    scope :by_created_start_date, -> (date) { where("monetary_transactions.created_at >= ?",  DateTime.parse(date.to_s).midnight) } 
    scope :by_created_end_date,   -> (date) { where("monetary_transactions.created_at <= ?",  DateTime.parse(date.to_s).end_of_day) } 
    scope :by_created_date,       -> (date) { parse_date = DateTime.parse(date.to_s); where(monetary_transactions: {created_at: parse_date.midnight..parse_date.end_of_day})}
    
    def self.filters
        return [:by_mode, :by_created_start_date, :by_created_end_date, :by_created_date]
    end
    
    
    
    def self.create_asset(payment, value)
        description =   "#{payment.person.full_name} ha pagado #{MonetaryTransaction.string_to_money(value)} " +
                        "de la cuota ##{payment.number} por valor de #{MonetaryTransaction.string_to_money(payment.value)} " + 
                        "del prestamo de #{MonetaryTransaction.string_to_money(payment.loan.debt)}"
        return MonetaryTransaction.create!(mode: MonetaryTransaction.ACTIVO, value: value, description: description, company: payment.company)
    end
    
    def self.string_to_money(s, precision = 0)
        ActionController::Base.helpers.number_to_currency(s, precision: precision)
    end
    
end
