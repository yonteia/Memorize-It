class FileException < Exception
  attr_reader :description
  
  def initialize descr
    @description = descr
  end
  
  def inspect
    to_s
  end
  
  def to_s
    "#{self.class.to_s}: #{description}"
  end
end

class FileNotFound < FileException ; end

class InvalidFile < FileException ; end