class TrackerUpdater

# Revert this! New perspective. 
# Get all new torrents through last 24 hours as RSS file. 
# Download and parse/search through. 
# Only one hit = no hammering.)

	def initialize
		@updated_trackers = []
		@updatepool = Tracker.where{updated_at < Time.now-86400}.all
	end
		
	def go!	
		@updatepool.each do |t|
		search = KeywordSearch.new(t.keywords)
		results = search.results
		timestamp = results[0].at_css('pubDate').text.to_time
		if timestamp > t.timestamp
			t.timestamp = timestamp
			@updated_trackers << t.id
			#sleep 3 #to avoid ban for hammering feed source?
		#else
		#	t.touch #why?
		end

	def save_list 
		someDBentry (with timestamps) = @updated_trackers
		if someDBentry.save
			@updated_trackers = nil
			self (TrackerUpdater) = nil
			send update success email to admin 
		else 
			alert admin of error via email!!!
			# retry?
		end
	end
end