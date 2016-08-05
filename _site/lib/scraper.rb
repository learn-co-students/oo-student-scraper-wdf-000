require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_doc = Nokogiri::HTML(open(index_url))
    # name: student.css("a div.card-text-container h4.student-name").text
    # location: student.css("a div.card-text-container p.student-location").text
    # profile_url: student.css("a").attribute("href").value
    # binding.pry
    students = index_doc.css("div.student-card")
    scraped_students = []
    students.each do |student|
    	student_hash = {
    		name: student.css("a div.card-text-container h4.student-name").text,
    		location: student.css("a div.card-text-container p.student-location").text,
    		profile_url: "http://127.0.0.1:4000/" + student.css("a").attribute("href").value
    	}
    	scraped_students << student_hash
    end
    scraped_students
  end

  def self.scrape_profile_page(profile_url)
  	profile_doc = Nokogiri::HTML(open(profile_url))
  	# profile_quote: profile_doc.css("div.profile-quote").text
  	# bio: profile_doc.css("div.bio-content.content-holder div.description-holder p").text
  	social_links = profile_doc.css("div.social-icon-container a")
  	student_hash = {}
  	social_links.each do |social_link|
  		# binding.pry
  		if social_link.attribute("href").text.include?("twitter")
  			student_hash[:twitter] = social_link.attribute("href").text
  		elsif social_link.attribute("href").text.include?("linkedin")
  			student_hash[:linkedin] = social_link.attribute("href").text
  		elsif social_link.attribute("href").text.include?("github")
  			student_hash[:github] = social_link.attribute("href").text
  		else
  			student_hash[:blog] = social_link.attribute("href").text
  		end
  	end
  	student_hash[:profile_quote] = profile_doc.css("div.profile-quote").text
  	student_hash[:bio] = profile_doc.css("div.bio-content.content-holder div.description-holder p").text
  	student_hash
  end

end

