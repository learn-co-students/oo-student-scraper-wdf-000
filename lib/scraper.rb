require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
   
   page = Nokogiri::HTML(open(index_url))
  
  students = []

   page.css(".student-card").map do |student|
    # binding.pry
    students << {name: student.css(".student-name").text, 
                location: student.css(".student-location").text, 
                profile_url: "http://127.0.0.1:4000/#{student.css('a')[0]['href']}"}
  end
   students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    page = Nokogiri::HTML(open(profile_url))

      page.css(".vitals-container .social-icon-container a").map do |social|
        if social['href'].include?('linkedin')
          student[:linkedin] = social['href']
        elsif social['href'].include?('github')
          student[:github] = social['href']
        elsif social['href'].include?('twitter')
          student[:twitter] = social['href']
        else
          student[:blog] = social['href']
        end
      end
    student[:profile_quote] = page.css(".profile-quote").text
    student[:bio] = page.css(".bio-content .description-holder").text.lstrip.rstrip
    student
# binding.pry

  end
    
  

end

# # Scraper.scrape_profile_page(profile_url)
# # => {:twitter=>"http://twitter.com/flatironschool",
#       :linkedin=>"https://www.linkedin.com/in/flatironschool",
#       :github=>"https://github.com/learn-co,
#       :blog=>"http://flatironschool.com",
#       :profile_quote=>"\"Forget safety. Live where you fear to live. Destroy your reputation. Be notorious.\" - Rumi",
#       :bio=> "I'm a school"
#      }