require 'net/http'
require 'slack-ruby-client'

managed_site_uri = {"site_name1" => "site_url1",
                       "site_name2" => "site_url2"}
#---------------------Slack_Api-----------------
Slack.configure do |conf|
  conf.token = 'XXXXXXXXXXXXXXXXXXXXXXXX'
end

client = Slack::RealTime::Client.new

client.on :hello do
  puts "connected."
end

client.on :message do |data|
  case data.text
  when 'a' then
    managed_site_uri.each do |key, value|
      uri = URI.parse(value)
      response = Net::HTTP.get_response(uri)
      response_code = response.code

      case response_code #response.code
      when "200"
        client.message(channel: data.channel, text: "サイト:#{key}は正常に動作しています. RESPONSE CODE:#{response_code} \n")
      else
        client.message(channel: data.channel, text: "サイト:#{key}に異常があります. RESPONSE CODE:#{response_code} \n")
      end
    end
  end
end

client.on :close do |_data|
  puts "Client is about to disconnect"
end

client.on :closed do |_data|
  puts "Client has disconnected successfully!"
end

client.start!
