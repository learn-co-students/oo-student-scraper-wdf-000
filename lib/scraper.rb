require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

	def self.scrape_index_page(index_url)
	  	doc = Nokogiri::HTML(open(index_url))
	  	
		link = "http://127.0.0.1:4000/"	

		doc.css("div.student-card a").collect do |person|
	  		student_hash = {}	
	  			
	  			student_hash[:name] = person.css("h4.student-name").text
	  			student_hash[:location] = person.css("p.student-location").text
	  			student_hash[:profile_url] = link + person.values[0]
	  			student_hash
	  	end
	end
  		

  def self.scrape_profile_page(profile_url)
  	doc = Nokogiri::HTML(open(profile_url))

  	student_profiles = {}
	
	student_profiles[:profile_quote] = doc.css("div.profile-quote").text 
  	student_profiles[:bio] = doc.css("div.description-holder p").text	

	doc.css("div.social-icon-container a").each do |student|
  		if student.attribute("href").value.include?("https://twitter.com/")
			student_profiles[:twitter] = student.attribute("href").value

		elsif student.attribute("href").value.include?("https://www.linkedin.com/")
  			student_profiles[:linkedin] = student.attribute("href").value

  		elsif student.attribute("href").value.include?("https://github.com/")
  			student_profiles[:github] = student.attribute("href").value

  		else
  			student_profiles[:blog] = student.attribute("href").value
  		end	
  	  end
	student_profiles
  end



end

