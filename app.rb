require 'sinatra'
require 'net/http'
require 'oga'

def update!
	pn, titles, timestamps = 0, [], []
	while pn
		url = URI.parse('https://torrentz.eu/feedA?f=added%3A1d&p=' + pn.to_s)
		response = Net::HTTP.get_response(url)
		if response.body.include?("item")
			doc = Oga.parse_xml(response.body)
			doc.xpath('//item/title').map {|t| titles << t.text}
			doc.xpath('//item/pubDate').map {|t| timestamps << t.text}
			pn += 1
		else
			pn = nil
		end
	end
	titles.zip(timestamps).uniq
end

def tracker_check
  hash = @list.to_h
  hash.select {|k, _| k.include?("Search string")}
  hash.select{ |k,v| k[/white.*2014/i] }



=begin
	"keywordslist".each do |keyword|
		if @list.include?('keyword')
			timestamp = "match-index"[1]
		timestamp = results[0].at_css('pubDate').text.to_time
		if timestamp > t.timestamp
			t.timestamp = timestamp
			@updated_trackers << t.id
=end

end

get '/run/?' do
	@list = update!
end

get '/?' do
	@list
	erb :index
end

__END__
@@layout
<html>
<head>
<body>
<%= yield %>
</body>
</head>
</html>

@@index 
<ul>
<% @list.each do |title, time| %>
<li>
<%= "The torrent " + "'" + title + "'" +  " was released on " + time %>
</li>
<% end %>
</ul>
