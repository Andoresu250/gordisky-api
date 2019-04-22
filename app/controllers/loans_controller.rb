class LoansController < ApplicationController
  before_action :verify_token
  before_action :is_company?
  before_action :set_loan, only: [:show, :update, :destroy, :pay]
  before_action :payment_value, only: :pay

  def index
    loans = @user.profile.loans.filter(params)
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
      return renderJson(:unprocessable, {errors: loan.errors.messages})
    end
  end
  
  def pay
    payments = @loan.payments.unpaids
    if payments.empty?
      return renderJson(:unprocessable, error: 'Este prestamo se encuentra pago en su totalidad')
    end
    unless is_number? @value
      return renderJson(:unprocessable, error: 'el valor a pagar debe ser valido')
    end
    value = @value.to_f
    total_debt = @loan.debt - @loan.paid
    if value <= 0 || value > total_debt
      return renderJson(:unprocessable, error: 'el valor a pagar debe ser valido')
    end
    ActiveRecord::Base.transaction do
      first_payment = payments.first
      value = first_payment.pay(value)
      first_payment.save! #for some reason after this save the payments array reduce the size 
      if value <= 0
        set_loan
        @loan.refresh_paids
        @loan.save!
        return render json: @loan, status: :ok
      end
      payments = @loan.payments.unpaids
      payments = payments.reverse
      payments.each do |payment|
        if value <= 0
          puts "asd"
          break
        end
        value = payment.pay(value)
        payment.save!
      end
      @loan.refresh_paids
      @loan.save!
      set_loan
      return render json: @loan, status: :ok
    end
    
  rescue ActiveRecord::RecordInvalid
    puts "Oops. We tried to do an invalid operation!"
    return renderJson(:unprocessable, error: 'No se pudo completar la operacion')
  end
  
  def project
    loan = Loan.new(loan_params)
    loan.company = @user.profile
    loan.complete_data
    loan.set_fake_payments
    if loan.valid?(:project)
      return render json: loan, status: :created
    else
      return renderJson(:unprocessable, {errors: loan.errors.messages})
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
    
    def payment_value
      return @value if @value = params[:loan][:value] rescue renderJson(:bad_request)
    end
end

