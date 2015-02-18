def prepare_tracker_keywords
		updatepool = Tracker.where{updated_at < Time.now-86400}.all
		id, keywords = [], []
		updatepool.each do |k|
			id << k.id
			keywords << k.keywords.split(' ')
		end
		id.zip(keywords)
end