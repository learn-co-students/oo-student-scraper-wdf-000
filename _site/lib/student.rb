require 'pry'
class Student

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url 

  @@all = []

  def initialize(student_hash)
    student_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  def self.create_from_collection(students_array)
    # iterate over the array of hashes
    students_array.map do |student|
      # create a new individual student using each hash
      self.new(student)
    end
  end

  def add_student_attributes(attributes_hash)
    # iterate over the given hash
    attributes_hash.each do |key, value|
      # assign the student attributes and values
      self.send(("#{key}="), value)
    end
  end

  def self.all
    @@all
  end
end

