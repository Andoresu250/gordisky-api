class CompaniesController < ApplicationController
  before_action :verify_token, only: [:create, :update, :destroy]
  before_action :is_admin?, only: [:create, :update, :destroy]
  before_action :set_company, only: [:show, :update, :destroy]

  def index
    companies = Company.filter(params)
    return renderCollection("companies", companies, CompanySerializer)
  end
  
  def show
    return render json: @company, status: :ok
  end
  
  def create
    company = Company.new(company_params)    
    if company.save
      return render json: company, status: :created
    else
      return renderJson(:unprocessable, {error: company.errors.messages})
    end
  end
  
  def update
    @company.assign_attributes(company_params)    
    if @company.save
      return render json: @company, status: :ok
    else
      return renderJson(:unprocessable, {error: @company.errors.messages})
    end
  end
  
  def destroy
    @company.destroy
    return renderJson(:no_content)
  end

  private
    
    def set_company
      return renderJson(:not_found) unless @company = Company.find_by_hashid(params[:id])
    end
    
    def company_params
      params.require(:company).permit(:name, :nit, :phone, :address)
    end
end
