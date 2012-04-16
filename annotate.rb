require './runnable.rb'
require './flags.rb'
require './char.rb'

require "highline/system_extensions"
include HighLine::SystemExtensions

class Annotate < Runnable
  def initialize
    @@TAB_SIZE = 2
  end
  
  def run file_name, flags
    if !File.exists? file_name then
      raise FileNotFound.new "File #{file_name} not found"
    end
    
    puts "processing #{file_name} ..."
    
    in_file = File.new file_name, 'r'
    out_file = File.new file_name + '.an.txt', 'a'
    indent = 0;
    
    out_file.write "<%Annotated>\n"
    indent += @@TAB_SIZE;
    
    out_file.write "\n"
    
   in_file.readlines.each do |line|
     if line =~ /\S/ then 
       $stdout.puts line.to_s
       $stdout.print '[s]kip, [p]rocess, []*]custom: '
       char = get_character
       if (char == $ESC)
        break
       end
       annotation = char.chr
       
       $stdout.print annotation + "\n"
        
       annotated_output = String.new
       indent.times {annotated_output += ' '}
       annotated_output = "<%#{annotation}>#{line.gsub(/ +/, ' ')}\n"   
       out_file.write(annotated_output)
     end
   end
   
   in_file.close
   out_file.close    
  end
end