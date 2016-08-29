require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
  	html = open(index_url)
  	doc = Nokogiri::HTML(html)

  	scraped_students = []
  	doc.css(".student-card").each do |student|
  		name = student.css("h4").text
  		# binding.pry
        location = student.css("p").text
        link = "http://127.0.0.1:4000/" + student.css("a").attribute("href").value
        scraped_students << {name: name, location: location, profile_url: link}
    	end
    scraped_students
  end


  	# get the html and convert into a Nokogiri object

  	# use the .css method to select the html elements that represent each student

  	# end
  	# use pry, figure out how to get the name, location, url of one student 

  	# iterate and do the above step for each student, stor values in a hash

  	# return an array of all thos hashes

  	# 3 students represented by 3 hashes
  	# [{name: "<Get this from scraping>", location: "<get from scraping", profile_url: <get form srcaping>}, {name:"", location:"", profile_url:""}, {}]


    def self.scrape_profile_page(profile_url)
  		scraped_student = {}


  		doc = Nokogiri::HTML(open(profile_url))
  		links = doc.css(".social-icon-container a").map {|link| link.attribute("href").value}
  		links.each do |link|
  		if link.include?("linkedin")
  			scraped_student[:linkedin] = link
  		elsif link.include?("github")
  			scraped_student[:github] = link
  		elsif link.include?("twitter")
  			scraped_student[:twitter] = link
  		else
  			scraped_student[:blog] = link
  		end
    end
    scraped_student[:profile_quote] = doc.css(".profile-quote").text
    scraped_student[:bio] = doc.css("p").text
    scraped_student
	end
end

