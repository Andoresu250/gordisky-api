class SessionSerializer < ApplicationSerializer
    attributes :email, :profile_type, :token, :profile
    
    def profile        
      case object.profile_type
      when "Admin"
          ActiveModelSerializers::SerializableResource.new(object.profile, serializer: AdminSerializer)
      when "Company"
          ActiveModelSerializers::SerializableResource.new(object.profile, serializer: CompanySerializer)
      end
    end
end
  