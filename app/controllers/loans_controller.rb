class LoansController < ApplicationController
  before_action :verify_token
  before_action :is_company?
  before_action :set_loan, only: [:show, :update, :destroy]

  def index
    loans = Loan.filter(params)
    return renderCollection("loans", loans, LoanSerializer)
  end
  
  def show
    return render json: @loan, status: :ok
  end
  
  def create
    loan = Loan.new(loan_params)    
    loan.company = @user.profile
    loan.complete_data
    if loan.save
      return render json: loan, status: :created
    else
      return renderJson(:unprocessable, {error: loan.errors.messages})
    end
  end
  
  def update
    @loan.assign_attributes(loan_params)    
    if @loan.save
      return render json: @loan, status: :ok
    else
      return renderJson(:unprocessable, {error: @loan.errors.messages})
    end
  end
  
  def destroy
    @loan.destroy
    return renderJson(:no_content)
  end

  private
    
    def set_loan
      return renderJson(:not_found) unless @loan = Loan.find_by_hashid(params[:id])
    end
    
    def loan_params
      params.require(:loan).permit(:amount, :interest, :debt, :fees, :fees_fulfilled, :remaining_fees, :frequency, :paid, :last_paid, :next_paid, :fee_value, :person_id)
    end
end

