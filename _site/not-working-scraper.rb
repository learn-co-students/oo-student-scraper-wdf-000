class Scraper

  def self.scrape_index_page(index_url)
    html_string = open(index_url)
    page = Nokogiri::HTML(html_string)
    student_scraper = []
    hash = {}
    array = []

    page.css("div.roster-cards-container div.student-card").each do |object|
      # hash[:name] = object.css("h4.student-name").map{ |el| el.text }.map do |name|

       object.css("h4.student-name").each do |name| name.text end

                object.css("h4.student-name").each do |name|
                  hash[:name] = name.text
                  object.css("p.student-location").each do |location|
                     hash[:location] = location.text
                     binding.pry
                  object.css("div.student-card a/@href").each do |html|
                    hash[:student_site] = html.text
                  end
                end
              end

    end

    array << hash

    # binding.pry
  end





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
          # object.css("@href").text

          # binding.pry
          # student_name = object.css("h4.student-name").text
          #
          # location = object.css("p.student-location").text
          #
          # student_site = "http://127.0.0.1:4000/#{object.attr('href')}"
          #
          hash
          # student_scraper << { name: student_name, location: location, profile_url: student_site}
        end
          #   object.css("h4.student-name").each do |name|
          #     hash[:name] = name.text
          #     object.css("p.student-location").each do |location|
          #        hash[:location] = location.text
          #        binding.pry
          #     object.css("div.student-card a/@href").each do |html|
          #       hash[:student_site] = html.text
          #     end
          #   end
          # end

      # end
      #
      # array << hash
      # student_scraper
      # binding.pry
    end

    def self.scrape_profile_page(profile_url)
      scraped_student = {}

    end

  end

  #each student object
  # page.css("div.roster-cards-container")
  #student name
  # page.css("h4.student-name").map{ |el| el.text }

  #student location
  # page.css("p.student-location").map{ |el| el.text }

  #student html
  # page.css("div.student-card a/@href").map{ |el| el.text }
  #
  # def self.scrape_index_page(index_url)
  #   html_string = open(index_url)
  #   page = Nokogiri::HTML(html_string)
  #   scraped_students = []
  #   hash = {}
  #   page.css("h4.student-name").each do |el|
  #       hash[:name] = el.text
  #           binding.pry
  #     end
  #     page.css("p.student-location").each do |el|
  #       hash[:location] = el.text
  #     end
  #     page.css("div.student-card a/@href").each do |el|
  #       hash[:student_html] = "http://127.0.0.1:4000/fixtures/student-site/#{el.text}"
  #     end
  #
  #   scraped_students << hash
  # end
