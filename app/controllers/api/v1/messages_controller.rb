class Api::V1::MessagesController < Api::V1::BaseController
  def index
    @messages = FindMessagesQuery.new(Message.all).call(filter_params)
  end

  def create
    message = Message.new(message_params)

    if message.save
      render json: message, status: :ok
    else
      render json: { errors: message.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.permit(:email, :first_name, :last_name, :amount)
  end

  def filter_params
    params.permit(:search_key, :search_value, :sort_key, :sort_direction)
  end
end
