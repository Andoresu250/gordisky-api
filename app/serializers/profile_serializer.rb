class ProfileSerializer < ApplicationSerializer
    attributes :type
    
    def type
        object.class.name
    end
end
  