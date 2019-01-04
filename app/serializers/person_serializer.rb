class PersonSerializer < ApplicationSerializer
  attributes :first_names, :last_names, :identification, :phone, :address, :lat, :lng, :type

end
