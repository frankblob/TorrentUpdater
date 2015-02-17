require 'sinatra'
require 'net/http'
require 'oga'

class Updater
	
	attr_reader :released_torrents, :start_time, :finish_time

	def initialize
		@start_time = Time.now
		@released_torrents = get_torrent_releases
		@tracker_keywords = prepare_tracker_keywords
		@regexkeywords = convert_keywords_to_regex
		@updated_matches = match_regex_and_torrents
#		update_tracker_timestamps
#		generate_updated_tracker_list
#		mail_admin_summary
		@finish_time = Time.now
	end

#private

	def get_torrent_releases
		pn, titles, timestamps = 0, [], []
		while pn < 1
			url = URI.parse('https://torrentz.eu/feedA?f=added%3A1d&p=' + pn.to_s)
			response = Net::HTTP.get_response(url)
			if response.body.include?("item")
				doc = Oga.parse_xml(response.body)
				doc.xpath('//item/title').map {|t| titles << t.text }
				doc.xpath('//item/pubDate').map {|t| timestamps << t.text }
				pn += 1
			else
				pn = nil
			end
		end
		titles.zip(timestamps).uniq
	end

	def prepare_tracker_keywords
			updatepool = Tracker.where{updated_at < Time.now-86400}.all
			keywords = []
			updatepool.each do |k|
				keywords << k.keywords.split(' ')
			end
			keywords
	end

	def convert_keywords_to_regex
		keywords = @tracker_keywords.map do |array_lineitem|
			builder = ""
			last = ""
			array_lineitem.each do |string_element|
			  if string_element[0] == "-"
					string_element.sub!(/^-/, '')
					last += '(?m)^(?!.*?' + string_element + ')'
				else 
					builder += '(?=.*?\b' + string_element + '\b)'	
				end
			end
			if last.empty?
				throwback = "/" + builder + ".*/i"	
			else 
				throwback = "/" + builder + ".*" + last + ".*$" + "/i"
			end
			Regexp.try_convert(throwback)
		end	
		keywords
	end

	def match_regex_and_torrents
		hash = @released_torrents.to_h
		@regex_keywords.map do |regex|  
			hash.select{ |k, _| k[regex]}
		end #  hash.select{ |k, _| k[/(?=.*?\bkeyword1\b)(?=.*?\bkeyword2\b)(?=.*?\bkeyword3\b).*(?m)^(?!.*?keyword4).*$/i]}
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
