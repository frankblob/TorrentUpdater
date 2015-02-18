	def generate_updated_tracker_list
		@updated_matches.map do |updated_tracker|
			updated_tracker[0]
		end
	end