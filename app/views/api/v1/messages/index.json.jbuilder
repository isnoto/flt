json.array! @messages do |article|
  json.extract! article ,:email, :first_name, :last_name, :amount
end
