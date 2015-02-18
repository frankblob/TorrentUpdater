	def update_tracker_timestamps
		@updated_matches.each do |array_item|
			time_insert = array_item[1].values.sort.last
			Tracker[id: array_item[0]].update(timestamp: time_insert) 
		end
	end