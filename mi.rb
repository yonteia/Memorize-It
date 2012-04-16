require './memorize.rb'
require './annotate.rb'
require './exceptions.rb'
require './flags.rb'

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
      rescue Exception => exception
        puts "Unknown Error"
      end
    else
      puts "No file specified."  
    end    
  end
end

puts ARGV.to_s

Runtime.new.process_arguments(ARGV).run



