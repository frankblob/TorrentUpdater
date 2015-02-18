def convert_keywords_to_regex
	id = []
	regex = []
	@tracker_keywords.map do |array_lineitem|
		builder = ""
		last = ""
		id << array_lineitem[0]
		array_lineitem[1].each do |string_element|
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
		regex << eval(throwback)
	end	
	id.zip(regex)
end