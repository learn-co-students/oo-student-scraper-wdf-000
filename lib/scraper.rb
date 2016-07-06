require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    student_array = []
    index = Nokogiri::HTML(open(index_url))
    index.css(".student-card").each do |card|
      student_array.push({
        :name => card.css(".card-text-container h4.student-name").text,
        :location => card.css(".card-text-container p.student-location").text,
        :profile_url => card.css("a").attribute("href").value
      })
    end

    student_array

  end

  def self.scrape_profile_page(profile_url)
    student_hash = {
      :twitter => nil,
      :linkedin => nil,
      :github => nil,
      :blog => nil
    }
    page = Nokogiri::HTML(open(profile_url))
    #below takes care of social links
    page.css(".social-icon-container a").each do |link|
      student_hash.each do |key, field|
        if link.attribute("href").value.include?(key.to_s)
          student_hash[key] = link.attribute("href").value
        end
      end
      if !(student_hash.values.include?(link.attribute("href").value))
        student_hash[:blog] = link.attribute("href").value 
      end
    end

    student_hash[:profile_quote] = page.css(".vitals-container div.profile-quote").text
    student_hash[:bio] = page.css(".bio-block div.description-holder p").text

    student_hash.delete_if{|k, v| v.nil?}
end

end
