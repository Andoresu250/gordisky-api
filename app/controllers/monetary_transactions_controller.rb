class MonetaryTransactionsController < ApplicationController
  before_action :verify_token
  before_action :is_company?
  before_action :set_monetary_transaction, only: [:show]
  
  def index
    transactions = @user.profile.monetary_transactions.filter(params)
    return renderCollection("monetaryTransactions", transactions, MonetaryTransactionSerializer)
  end
  
  def resume
    total_inverted = @user.profile.loans.sum(:amount)
    total_inverted_with_interest = @user.profile.loans.sum(:debt)
    day_date    = params[:day]
    week_date   = params[:week]
    month_date  = params[:month]
    start_date  = params[:start_date]
    end_date    = params[:end_date]
    
    if start_date || end_date
      start_date = DateTime.parse(start_date) if start_date
      end_date = DateTime.parse(end_date) if end_date
    else
      if day_date || week_date || month_date
        if day_date
          start_date = DateTime.parse(day_date).beginning_of_day
          end_date = DateTime.parse(day_date).end_of_day
        end
        if week_date
          start_date = DateTime.parse(week_date).beginning_of_week 
          end_date = DateTime.parse(day_date).end_of_week
        end
        if month_date
          start_date = DateTime.parse(month_date).beginning_of_month 
          end_date = DateTime.parse(day_date).end_of_month 
        end
      end
    end
    
    transactions = @user.profile.monetary_transactions
    transactions = transactions.by_created_start_date(start_date) if start_date
    transactions = transactions.by_created_end_date(end_date) if end_date
    
    loans = @user.profile.loans
    profit = 0
    loans.each do |loan|
      profit += loan.profit(start_date, end_date)
    end
    
    total_assets = transactions.assets.sum(:value)
    total_liabilities = transactions.liabilities.sum(:value)
    total_gain = total_assets - total_liabilities
    return renderJson(:ok, {
      total_inverted: total_inverted, 
      total_inverted_with_interest: total_inverted_with_interest, 
      total_assets: total_assets,
      total_liabilities: total_liabilities,
      total_gain: total_gain,
      tota_profit: profit
    })
  end
  
  def show
    return render json: @transaction, status: :ok
  end
  
  def create
    transaction = MonetaryTransaction.new(monetary_transaction_params)
    transaction.company = @user.profile
    if transaction.save
      return render json: transaction, status: :created
    else
      return renderJson(:unprocessable, {errors: transaction.errors.messages})
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_monetary_transaction
      return renderJson(:not_found) unless @transaction = MonetaryTransaction.find_by_hashid(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def monetary_transaction_params
      params.require(:monetary_transaction).permit(:value, :description, :mode)
    end
end
