require 'sinatra'
require 'net/http'
require 'oga'

class Updater
	
	def initialize
		@start_time = Time.now
		@released_torrents = get_torrent_releases
		@tracker_keywords = prepare_tracker_keywords
		convert_keywords_to_regex
		match_regex_and_torrents
		update_tracker_timestamps
		generate_updated_tracker_list
		mail_admin_summary
		@finish_time = Time.now
	end

	def get_torrent_releases
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

	def prepare_tracker_keywords
			@updatepool = Tracker.where{updated_at < Time.now-86400}.all
			keywords = []
			@updatepool.each do |k|
				keywords << k.keywords.split(' ')
			end
			keywords
	end

	def convert_keywords_to_regex
		keywords = @tracker_keywords
		keywords.map! do |lineitem|
			builder = ""
			last = ""
			throwback = lineitem.each do |element|
									  if element[0] == "-"
											element.sub!(/^-/, '')
											last += "#{'(?m)^(?!.*?' + element + ')'}"
										else 
											builder += "#{'(?=.*?\b' + element + '\b)'}"	
										end
										"/" + builder + ".*" + last + ".*$" + "/i"
									end
		end	
	end

	def match_regex_and_torrents
		hash = @released_torrents.to_h
		keywords.each do |regex|
			hash.select{ |k, _| k[regex]}
			#  hash.select{ |k, _| k[/(?=.*?\bkeyword1\b)(?=.*?\bkeyword2\b)(?=.*?\bkeyword3\b).*(?m)^(?!.*?keyword4).*$/i]}
	end

	def update_tracker_timestamps
				@updated_trackers = []
	end

	def generate_updated_tracker_list
		# something
	end

	def mail_admin_summary
		# something
	end

end

=begin
keywords.each do |keys|
words = keys.split(' ')

hash.select{ |k, _| k[/(?=.*?\bkeyword1\b)(?=.*?\bkeyword2\b)(?=.*?\bkeyword3\b).*(?m)^(?!.*?keyword4).*$/i]}		
=end

get '/verysecreturl33403430/?' do
	Updater.new
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