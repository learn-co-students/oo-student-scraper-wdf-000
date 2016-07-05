require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

	def self.scrape_index_page(html)
		#html = File.read(html)
		info  = Nokogiri::HTML(open(html))
		localhost = "http://127.0.0.1:4000/"
		#student name
		#info.css(".roster-cards-container div.student-card").first.css("div.card-text-container h4").text
		#student location
		#info.css(".roster-cards-container div.student-card").first.css("div.card-text-container p").text
		#student profile_url
		#info.css(".roster-cards-container div.student-card").first.css("a").attribute("href").value
		students = []
		info.css(".roster-cards-container div.student-card").each do |x|
			tmp = {:name => "", :location => "", :profile_url => ""}
			tmp[:name] = x.css("div.card-text-container h4").text
			tmp[:location] = x.css("div.card-text-container p").text
			tmp[:profile_url] = localhost + x.css("a").attribute("href").value
			students << tmp
		end
		return students
	end

	def self.scrape_profile_page(html)
		info  = Nokogiri::HTML(open(html))
		#social media
		#returns array
		#info.css("div.social-icon-container a").collect { |x| x.attribute("href").value }
		#bio
		#info.css("div.description-holder p").text
		#profile_quote
		#info.css("div.vitals-text-container div").text
		#tmp = {:linkedin => "", :github => "", :blog => "", :profile_quote => "", :twitter => "" ,:bio => ""}
		tmp = {}
		tmp[:profile_quote] = info.css("div.vitals-text-container div").text
		tmp[:bio] = info.css("div.description-holder p").text
		arr = info.css("div.social-icon-container a").collect { |x| x.attribute("href").value }
		arr.each do |x|
			if x.match(/.*twitter.*/)
				tmp[:twitter] = x
			elsif x.match(/.*linkedin.*/)
				tmp[:linkedin] = x
			elsif x.match(/.*github.*/)
				tmp[:github] = x
			elsif x.match(/.*/)
				tmp[:blog] = x
			end
		end
		tmp
	end
end

#puts Scraper.scrape_index_page( "http://127.0.0.1:4000/fixtures/student-site/index.html" ).first
#Scraper.scrape_profile_page ( "http://127.0.0.1:4000/fixtures/student-site/students/joe-burgess.html" )
