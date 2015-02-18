require 'net/http'
require 'oga'

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