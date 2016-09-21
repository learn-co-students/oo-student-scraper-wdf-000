class Student

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url

  @@all = []

  def initialize(student_hash)
    student_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self

  #use #send method to assign student hashes
  #@@all << self


  end

  def self.create_from_collection(students_array)
    students_array.each {|name| self.new(name)}
  #return value of Scraper.scrape_index_page = argument
  #iterates over the array of hashes and Student.new from each hash

  end

  def add_student_attributes(attributes_hash)
    attributes_hash.each {|key, value| self.send(("#{key}="), value)}
  #return value of scraper.scrape_profile_page = argument
  #iterates over :hash and uses #send to assign student hashes

  end

  def self.all
    @@all
  end
end
