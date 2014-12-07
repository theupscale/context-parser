# encoding: utf-8
module KeywordParser
	def density_report(text,pings,keywords)
		density_report = Hash.new
		words = KeywordParser.get_words_from_text(text)

		words.each_with_index do |word_arr,i|
			word = word_arr[0]
			occurs_at = word_arr[1]

			badchars = ["’s","”",",",":",".",'"',")","("]
			badchars.each do |c|
				if (word.starts_with?(c))
				occurs_at += 1
				end
				word = word.gsub(c,'')
			end

			if (pings.has_key?(word))
				lengths_to_check = pings[word]
				lengths_to_check.each do |length|
					combination = text[occurs_at,length].downcase
					if (keywords.has_key?(combination))
						if (density_report.has_key?(combination))
						density_report[combination] << i
						else
							density_report[combination] = [i]
						end
					end
				end
			end
		end
		return density_report
	end

	def load_keywords
		keywords = Hash.new
		pings = Hash.new
		Keyword.all.each do |k|
			k.name = k.name.strip.downcase
			keywords[k.name] = 0
			ping_word = k.name.downcase

			word_count = k.name.split(" ").length
			word_length = k.name.length
			if (word_count > 0)
				ping_word = k.name.split(" ").first.strip.downcase
			end

			if(!pings.has_key?(ping_word))
				pings[ping_word] = [word_length]
			else
				if !pings[ping_word].include?(word_length)
				pings[ping_word] << word_length
				end
			end
		end
		return [keywords,pings]
	end

	def get_words_from_text(text)
		if (text!=nil)
			indexes = [-1]
			text.scan(/\s/) do |c|
				indexes << $~.offset(0)[0]
			end
			indexes = indexes.collect {|r| r+1}
			words = []
			indexes.each_with_index do |idx,i|
				last_index = indexes[i+1]
				if (last_index==nil)
				last_index = text.length
				else
				last_index = indexes[i+1]-1
				end
				word = text[idx,last_index-idx]
				if (word!=nil)
					word = word.downcase
					words << [word,idx]
				end
			end
		return words
		end
	end
	
	
	def consolidate_keywords(keyword_report)
		to_remove = []
		keyword_report.keys.each do |keyword|
			parent = Keyword.alias_of(keyword)
			if (parent != nil)
				if (keyword_report.keys.include?(parent.name.downcase))
				keyword_report[parent.name.downcase].concat(keyword_report[keyword])
				else
				keyword_report[parent.name.downcase] = keyword_report[keyword]
				end
			to_remove << keyword
			end
		end
		to_remove.each do |k|
			keyword_report.delete(k)
		end
		return keyword_report
	end

	def calculate_keyword_scores(keyword_report,text_length)
		keyword_scores = Hash.new
		scale_factor = (1.0/text_length) * 1.8
		keyword_report.keys.each do |k|
			occurances = keyword_report[k]
			score = 0
			occurances.each do |index|
				x = index * scale_factor
				weight = 1+(-((0.8-(-x+0.9)**2)**0.6)/(2.0**(-x+1.2)))
				score = score + weight
			end
			keyword_scores[k] = score.abs.round(2)
		end
		return keyword_scores
	end

	def context_relevancy_report(keyword_scores)
		puts "Keyword Scores == #{keyword_scores.inspect()}"
		relevant_contexts = Hash.new
		KeywordContext.all.each do |c|
			must_rules = c.must_have_rules
			valid = true
			
			expected_proportions = Hash.new
			actual_proportions = Hash.new
			
			must_score = 0
			must_rules.each do |rule|
				unless rule.keyword ==nil
					keyword_name = rule.keyword.name.downcase
					valid = valid && keyword_scores.has_key?(keyword_name)
					if (valid)
						expected_proportions[keyword_name] = rule.proportion
						actual_proportions[keyword_name] = keyword_scores[keyword_name]
						must_score = must_score + keyword_scores[keyword_name]*rule.weight
					else
						break
					end
				end
			end
			
			must_not_rules = c.must_not_rules
			must_not_rules.each do |rule|
				unless rule.keyword ==nil
					keyword_name = rule.keyword.name.downcase
					valid = valid && !keyword_scores.has_key?(keyword_name)
					if (!valid)
						break
					end
				end
			end

			if (valid)
				unless (expected_proportions.empty? || expected_proportions.keys.count == 1)
					variance_penalty = compute_variance_penalty(expected_proportions,actual_proportions)
				else
					variance_penalty = 1
				end
				
				score = 0
				score  = must_score * variance_penalty
				
				c.atleast_this_rules.each do |rule|
					unless rule.keyword ==nil
						keyword_name = rule.keyword.name
						if (keyword_scores.has_key?(keyword_name.downcase))
							tmp_score = keyword_scores[keyword_name.downcase]
							score += tmp_score * rule.weight
							puts "keyword name #{keyword_name} has a score of #{tmp_score}  - #{score}"
						end
					end
				end
				
				c.should_not_rules.each do |rule|
					unless rule.keyword ==nil
						keyword_name = rule.keyword.name
						if (keyword_scores.has_key?(keyword_name.downcase))
							tmp_score = keyword_scores[keyword_name.downcase]
							score -= tmp_score * rule.weight
							puts "keyword name #{keyword_name} has a score of #{tmp_score}  - #{score}"
						end
					end
				end
				
				relevant_contexts[c.name] = score.round(2) if score > 1
			end
		end
		return relevant_contexts
	end

	def normalize_values(hash_map)
		sum = 0.0
		hash_map.keys.each do |k|
			sum = sum + hash_map[k]
		end
		hash_map.keys.each do |k|
			hash_map[k] = hash_map[k]/sum
		end
	end

	def compute_variance_penalty(expected_proportions,actual_proportions)
		normalize_values(expected_proportions)
		normalize_values(actual_proportions)
		maximum_variance = maximum_variance(expected_proportions.values)
		actual_variance = calculate_variance(expected_proportions,actual_proportions)
		penalty = 1 - (actual_variance/maximum_variance)
		return penalty
	end

	def calculate_variance(expected,actual)
		total_diff = 0
		expected.keys.each do |k|
			difference = (expected[k] - actual[k]).abs
			total_diff = difference + total_diff
		end
		return total_diff
	end

	def maximum_variance(values)
		min = values.first
		sum = 0
		values.each do |v|
			if v <= min
			min = v
			end
			sum = sum + v
		end
		return 2*(sum - min)
	end

	module_function :density_report,:load_keywords,:get_words_from_text,:consolidate_keywords,:calculate_keyword_scores,:context_relevancy_report,:normalize_values,:compute_variance_penalty,:maximum_variance,:calculate_variance
end
