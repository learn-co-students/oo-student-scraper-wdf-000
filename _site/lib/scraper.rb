require 'open-uri'
#uri is part of ruby
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html_string = open(index_url)
    page = Nokogiri::HTML(html_string)
    # student_scraper = []
    # hash = {}

    page.css("div.roster-cards-container div.student-card a").map do |object|
      # hash[:name] = object.css("h4.student-name").map{ |el| el.text }.map do |name|
        hash = {}
        hash[:name] = object.css("h4.student-name").text
        hash[:location] = object.css("p.student-location").text
        # hash[:profile_url] =  "http://127.0.0.1:4000/#{object.attr('href')}"
        hash[:profile_url] = "http://127.0.0.1:4000/#{object.attr('href')}"

        hash
      end

  end

  def self.scrape_profile_page(profile_url)
    html_string = open(profile_url)
    page = Nokogiri::HTML(html_string)
    scraped_student = []
    array = []

    array = page.css("div.main-wrapper.profile div.social-icon-container").map do |object|
        student = {}

        social = object.css("a/@href").map do |el| el.text end
          social.each do |el|
            if el.include?("twitter")
              student[:twitter] = el
            elsif el.include?("linkedin")
              student[:linkedin] = el
            elsif el.include?("github")
              student[:github] = el
            else
              student[:blog] = el
            end
          end

          student[:profile_quote] = page.css("div.profile-quote").text
          student[:bio] = page.css("div.description-holder p").text
        # binding.pry
        student
      end
    # student
    # scraped_student

    array[0]
    # binding.pry
  end

end




# def self.scrape_profile_page(profile_url)
#   html_string = open(profile_url)
#   page = Nokogiri::HTML(html_string)
#   scraped_student = []
#   array = []
#
#   array = page.css("div.main-wrapper.profile div.social-icon-container").map do |object|
#       student = {}
#         student[:twitter] = object.css("a/@href")[1].text
#         student[:linkedin] = object.css("a/@href")[2].text
#         student[:github] = object.css("a/@href")[1].text
#         student[:profile_quote] = page.at("div.profile-quote").text
#         student[:bio] = page.css("div.description-holder p").text
#       binding.pry
#       student
#     end
#   # student
#   # scraped_student
#
#   array[0]
#   # binding.pry
# end
#
# end
