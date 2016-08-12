require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    scraped_students = []
    url = "http://127.0.0.1:4000/"
    page.css("div.student-card a").each do |student|
      scraped_students << {
      :name => student.css("h4.student-name").text,
      :location => student.css("p.student-location").text,
      :profile_url => url + student.values[0]
    }
  end
  scraped_students
  end

  def self.scrape_profile_page(profile_url)
    index = Nokogiri::HTML(open(profile_url))
    scraped_student = {}
    networks = index.css("div.vitals-container a")
    networks.each do |social|
      # binding.pry
      if social.attribute("href").value.include?("twitter")
        scraped_student[:twitter] = social.attribute("href").value
      elsif social.attribute("href").value.include?("linkedin")
        scraped_student[:linkedin] = social.attribute("href").value
      elsif social.attribute("href").value.include?("github")
        scraped_student[:github] = social.attribute("href").value
      elsif social.attribute("href").value.include?("joe")
        scraped_student[:blog] = social.attribute("href").value
      end
    end
    scraped_student[:profile_quote] = index.css("div.profile-quote").text
    scraped_student[:bio] = index.css("div.description-holder p").text
    # binding.pry
    scraped_student
  end

end

#
# if social.css("a").attribute("href").value.include?("twitter")
#   scraped_student[:twitter] = social.css("a").attribute("href").value
# elsif social.css("a").attribute("href").value.include?("linkedin")
#   scraped_student[:linkedin] = social.css("a").attribute("href").value
# elsif social.css("a").attribute("href").value.include?("github")
#   scraped_student[:github] = social.css("a").attribute("href").value
# elsif social.css("a").attribute("href").value.include?("joe")
#   scraped_student[:blog] = social.css("a").attribute("href").value
# end
