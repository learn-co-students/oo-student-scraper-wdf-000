require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)

    html = open(index_url)
    docs = Nokogiri::HTML(html)
    array = []

      docs.css("div.student-card a").each do |stu|

        name = stu.css("div.card-text-container h4").text
        location = stu.css("div.card-text-container p").text
        profile = "http://127.0.0.1:4000/#{stu.attr('href')}"

        array << {name: name, location: location, profile_url: profile}

      end

  array

  end

  def self.scrape_profile_page(profile_url)
    docs = Nokogiri::HTML(open(profile_url))
    student = {}
    student_social = []

    docs.css("div.social-icon-container a").each do |stud|
      student_social << stud.attr('href')
    end

    student_social.each do |str|
      if str.include?("twitter")
        student[:twitter] = str
      elsif str.include?("linkedin")
        student[:linkedin] = str
      elsif str.include?("github")
        student[:github] = str
      else str.include?("blog")
        student[:blog] = str
      end
    end


    # if student_social[0].include?("twitter")
    #   student[:twitter] = student_social[0]
    # end

    # if student_social[1] != nil
    #   student[:linkedin] = student_social[1]
    # end
    #
    # if student_social[2] != nil
    #   student[:github] = student_social[2]
    # end
    #
    # if student_social[3] != nil
    #   student[:blog] = student_social[3]
    # end

    if  docs.css("div.vitals-text-container div.profile-quote").text
      student[:profile_quote] = docs.css("div.vitals-text-container div.profile-quote").text
    end

    if docs.css("div.vitals-text-container div.profile-quote").text
      student[:bio] = docs.css("div.details-container p").text
    end


    student
  # binding.pry
  end

end
