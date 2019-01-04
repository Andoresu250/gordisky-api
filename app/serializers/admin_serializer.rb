class AdminSerializer < ApplicationSerializer
    attributes :name
    
    def full_name
        object.full_name
    end
end