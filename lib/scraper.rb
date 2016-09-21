require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    #index_url = Nokogiri::HTML(open("http://104.236.196.127:7061/fixtures/student-site/"))
    index_url = Nokogiri::HTML(open("http://104.236.196.127:7061/fixtures/student-site/"))
    #binding.pry

    index_url.css(".student-card").map do |info|
      {
        :name => info.css("h4").text,
        :location => info.css("p").text,
        :profile_url => "http://127.0.0.1:4000/" + info.css("a").attribute("href").value
        #:profile_url => info.css("a").attribute("href").value
      }
    end
  end
  #uses nokogiri and open_URI to access page; return value is an array of hashes where each hash represents an individual student
  #keys for Student hash should be :name, :location, :profile_url
  #colection of students: doc.css(".student-card")
  #individual student name: doc.css("student-card").doc.css.("h4").text
  #location: doc.css("student-card").doc.css.("p").text
  #profile_url: doc.css("student-card").doc.css("a").attribute("href").value
  #doc = Nokogiri::HTML(open("http://104.236.196.127:7061/fixtures/student-site/"))
  #binding.pry



  def self.scrape_profile_page(profile_url)
    profile_url = Nokogiri::HTML(open(profile_url))
    profile = profile_url.css("div.social-icon-container")

    student_attributes = {}

    social_media = profile.css("a").map {|social| social.attribute("href").value}
    social_media.each do |social|
      if social.include?("twitter")
        student_attributes[:twitter] = social
      elsif social.include?("linkedin")
        student_attributes[:linkedin] = social
      elsif social.include?("github")
        student_attributes[:github] = social
      else
        student_attributes[:blog] = social
      end
    end

    student_attributes[:profile_quote] = profile_url.css("div.profile-quote").text
    student_attributes[:bio] = profile_url.css("div.description-holder p").text
    student_attributes

  #profile_url changed in RSPEC otherwise connection refused
  #nokogiri & open_URI; nested iteration; return value is hash with key/value pairs for each student, account for students with no social media
  #:keys are :twitter, :linkedin, :github, :blog,:profile_quote, :bio
  #social_media: doc.css("div.social-icon-container a")
  #social_media_sites: doc.css("div.social-icon-container a").attribute("href").value
  #profile_quote: doc.css("div.profile-quote").text
  #bio: doc.css("div.description-holder p").text
  #doc = Nokogiri::HTML(open("http://104.236.196.127:7061/fixtures/student-site/students/joe-burgess.html")) #changed from "http://127.0.0.1:4000/" connection refused over port on Learn IDE
  #binding.pry


  end
end
