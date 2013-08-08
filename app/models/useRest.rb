require 'net/http'

Net::HTTP.start('localhost', 3000) do |http|
  response = http.get('/transaction/execute/3', 'Accept' => 'text/xml')

  #Do something with the response.

  puts "Code: #{response.code}" 
  puts "Message: #{response.message}"
  puts "Body:\n #{response.body}"
end