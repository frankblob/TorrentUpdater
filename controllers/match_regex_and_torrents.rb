def match_regex_and_torrents
	hash = @released_torrents.to_h
	@regex_keywords.each do |tracker_regex|
		regex = tracker_regex[1]
		matching_torrents = hash.select{ |k, _| k[regex]}
		if matching_torrents.empty?
			@regex_keywords.delete(@regex_keywords.assoc(tracker_regex[0]))
		else
			tracker_regex.pop
			tracker_regex.push(matching_torrents)
		end
	end
end