require "sinatra"
require "sinatra/reloader"
require "http"

EXCHANGE_RATES_KEY= ENV.fetch("EXCHANGE_RATES_KEY")

get("/") do
  api_url = "https://api.exchangerate.host/list?access_key=#{EXCHANGE_RATES_KEY}"

  @raw_response = HTTP.get(api_url)

  @string_response = @raw_response.to_s

  @parsed_response = JSON.parse(@string_response)

  @currencies = @parsed_response.fetch("currencies")

  erb(:homepage)

end

get("/:from_currency") do

  @the_symbol = params.fetch("from_currency")
  
  api_url = "https://api.exchangerate.host/list?access_key=#{EXCHANGE_RATES_KEY}"

  @raw_response = HTTP.get(api_url)

  @raw_string = @raw_response.to_s

  @parsed_data = JSON.parse(@raw_string)

  @currencies = @parsed_data.fetch("currencies")

  erb(:step_one)

end


get("/:from_currency/:to_currency") do
  @from = params.fetch("from_currency")
  @to = params.fetch("to_currency")

  @converter_api_url = "https://api.exchangerate.host/convert?access_key=#{EXCHANGE_RATES_KEY}&from=#{@from}&to=#{@to}&amount=1"
  @raw_response = HTTP.get(@converter_api_url)
  @raw_string = @raw_response.to_s
  @parsed_data = JSON.parse(@raw_string)
  @amount = @parsed_data.fetch("result")

  erb(:step_two)
end
