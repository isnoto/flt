module ApiHelper
  def json_response
    JSON.parse(response.body, symbolize_names: true)
  rescue JSON::ParserError
    response.body
  end
end
