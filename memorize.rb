require './runnable.rb'
require './flags.rb'
require './char.rb'

require "highline/system_extensions"
include HighLine::SystemExtensions

class Memorize < Runnable

  def initialize
    
    @file = nil 
  end
    
  def run file_name, flags
    
    if !File.exists? file_name then
      raise FileNotFound.new "File #{file_name} not found"
    end
    
    puts "processing #{file_name}"
    
    in_file = File.new file_name, 'r'
    
    in_file.each do |line|
      
      if flags.file_annotated then
        line  =~ /<%([\S]+)>/
        if $1.to_s.downcase == 's' or $1.to_s.downcase == 'annotated' then       
          next
        end
        
        line.gsub!(/<%[\S]+>/, "")
  
      end
      
      line.chomp!
            
      if flags.cheat then
        puts line
      end

      line.each_byte do |char|
        
        if flags.ignore_whitespace and char.chr == " " then
          print char.chr   
          next
        end
              
        success = (read_char = get_character) == char        
        success |= (flags.ignore_case and (read_char.chr.downcase == char.chr.downcase)) 
        
        if !success then
          if read_char == $ESC 
           exit
          elsif read_char == $CR # cheat
            print char.chr
            next
          end
                  
          redo
        end
        print char.chr
      end
    end
    
    in_file.close
  end

end