class Student

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url 

  @@all = []

  # hooks
  def initialize(scraped_student)
    scraped_student.each {|attr, value| self.send("#{attr}=", value)}
    @@all << self
  end

  def self.create_from_collection(scraped_students)
    scraped_students.each do|scraped_student|
      Student.new(scraped_student)
    end
  end

  def add_student_attributes(scraped_student)
    scraped_student.each {|attr, value| self.send("#{attr}=", value)}
    self
  end

  # self.all - Class Method, class Getter
  def self.all
    @@all 
  end
end

