require './memorize.rb'
require './exceptions.rb'
class Flags
  attr_reader :ignore_whitespace  
  attr_reader :annotate
  attr_reader :file_annotated
  
  def initialize 
    @ignore_whitespace = false
    @annotate = false
    @file_annotated = false
  end
  
  ##
  ## @brief set the ignore_whitespace flag
  ## Tells memorize to ignore whitespace when testing if your test matches the document
  def set_flag_i
    @ignore_whitespace = true
  end
  
  ##
  ## @brief set mi for Annotate mode
  def set_flag_a
    @annotate = true
  end
  
  ##
  ## @brief tells mi that the file is annotated
  def set_flag_f
    @file_annotated = false
  end
  
  ##
  ## @brief Tries variations of the flag passed in to see if they match  
  def method_missing (method, *args, &block)
    if method.to_s.start_with?('set_flag_')            
      flag = method.to_s.partition('set_flag_')[2]
      if flag.length > 1 then
        send "set_flag_" + flag[0]
      else
        puts "Invalid flag \"#{flag}\""
      end
    end
  end
end

class Runtime
  attr_accessor :flags
  attr_accessor :file_name
  
  def initialize
    @flags = Flags.new
    @file_name = String.new
  end
  
  def process_arguments args
    args.each do|arg|
      if arg[0] == '-' then
        @flags.send("set_flag_" + arg.slice(1..arg.length).downcase)
      else
        @file_name = arg
      end
    end
    
    self
  end
  
  def run
    if @file_name.length > 0 then
      begin
        if flags.annotate
          Annotate.new.run(@file_name, @flags)
        else
          Memorize.new.run(@file_name, @flags)
        end
      rescue FileException => exception
        puts exception.to_s
      else
        puts "Unknown Error"
      end
    else
      puts "No file specified"  
    end    
  end
end

Runtime.new.process_arguments(ARGV).run



