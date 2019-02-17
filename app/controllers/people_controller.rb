class PeopleController < ApplicationController
  before_action :verify_token
  before_action :is_company?
  before_action :set_person, only: [:show, :update, :destroy]

  def index
    people = Person.filter(params)
    return renderCollection("people", people, PersonSerializer)
  end
  
  def show
    return render json: @person, status: :ok
  end
  
  def create
    person = Person.new(person_params)    
    if person.save
      return render json: person, status: :created
    else
      return renderJson(:unprocessable, {errors: person.errors.messages})
    end
  end
  
  def update
    @person.assign_attributes(person_params)    
    if @person.save
      return render json: @person, status: :ok
    else
      return renderJson(:unprocessable, {errors: @person.errors.messages})
    end
  end
  
  def destroy
    @person.destroy
    return renderJson(:no_content)
  end

  private
    
    def set_person
      return renderJson(:not_found) unless @person = Person.find_by_hashid(params[:id])
    end
    
    def person_params
      params.require(:person).permit(:first_names, :last_names, :identification, :phone, :address, :lat, :lng)
    end
end
