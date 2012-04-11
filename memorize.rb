class Memorize

  def initialize
    @file = nil 
  end
  
  def run file_name, flags
    
    if !File.exists? file_name then
      raise FileNotFound.new "File #{file_name} not found"
    end
    
    puts "processing #{file_name}"
  end

end