require 'sinatra'
#require 'net/http' -relocated to get_torrent_releases.rb
#require 'oga'

class Updater
	
	attr_reader :released_torrents, :start_time, :finish_time

	def initialize
		@start_time = Time.now
		@released_torrents = get_torrent_releases
		@tracker_keywords = prepare_tracker_keywords
		@regex_keywords = convert_keywords_to_regex
		@updated_matches = match_regex_and_torrents
		update_tracker_timestamps
		generate_updated_tracker_list
#		mail_admin_summary
#		mail_users_with_new_releases
		@finish_time = Time.now
	end

private

require_relative 'controllers/init'

	def mail_admin_summary
		# something
	end

	def mail_users_with_new_releases
		# something
	end

end

get '/verysecreturl33403430/?' do
	Updater.new
end

get '/?' do
	@list = @updated_matches.map do |new_torrent|
		new_torrent[1]
	end
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
<% @list.each do |item| %>
	<% item.each do |new_torrent| %>
		<li>
		<%= "'" + new_torrent[0] + "'" + " was released on " + new_torrent[1] %>
		</li>
	<% end %>
<% end %>
</ul>
