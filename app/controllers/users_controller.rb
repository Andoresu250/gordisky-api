class UsersController < ApplicationController

  before_action :verify_token
  before_action :is_admin?, only: [:index, :create, :destroy]
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :verify_user, only: [:show, :update]

  def index
    users = User.filter(params)
    return renderCollection("users", users, SessionSerializer)
  end
  
  def show    
    return render json: ActiveModelSerializers::SerializableResource.new(@this_user, each_serializer: SessionSerializer), status: :ok
  end
  
  def create
    user = User.new(user_params)   
    case user.profile_type
    when "Company"
      profile = Company.new(company_params)
    else
      profile = nil
    end
    unless profile.nil?
      return renderJson(:unprocessable, {error: {profile: profile.errors.messages}}) unless profile.save
    end
    user.profile = profile
    if user.save
      return render json: ActiveModelSerializers::SerializableResource.new(user, each_serializer: SessionSerializer), status: :created
    else
      profile.destroy unless profile.nil?
      return renderJson(:unprocessable, {error: user.errors.messages})
    end
  end
  
  def update    
    @this_user.assign_attributes(user_params, {override: false})    
    profile = @this_user.profile
    case @this_user.profile_type
    when "Company"
      profile.assign_attributes(company_params, {override: false})
      return renderJson(:unprocessable, {error: {profile: profile.errors.messages}}) unless profile.save
    end
    if @this_user.save
      return render json: ActiveModelSerializers::SerializableResource.new(@this_user, each_serializer: SessionSerializer), status: :ok
    else
      return renderJson(:unprocessable, {error: @this_user.errors.messages})
    end
  end
  
  def destroy
    @this_user.destroy
    return renderJson(:no_content)
  end

  private

  def set_user
    return renderJson(:not_found) unless @this_user = User.find_by_hashid(params[:id])
  end

  def user_params        
    params.require(:user).permit(:email, :profile_type, :password, :password_confirmation)
  end

  def company_attributes
    [:name, :nit, :phone, :address]
  end

  def company_params    
    begin
      params.require(:user).require(:profile).permit(:name, :nit, :phone, :address)
    rescue
      {}
    end
  end

  def verify_user
    return renderJson(:unauthorized) if !@user.is_admin? && @this_user.id != @user.id
  end
end
