class Message < ApplicationRecord
  validates :first_name, :last_name, :amount, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'format invalid' }
end
