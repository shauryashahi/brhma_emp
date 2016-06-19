json.array!(@employers) do |employer|
  json.extract! employer, :id, :name, :email, :date_of_birth, :gender, :location, :phone_number
  json.url employer_url(employer, format: :json)
end
