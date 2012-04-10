
class Flags
  attr_reader :ignore_whitespace  
  
  def initialize 
    @ignore_whitespace = false
  end
  
  def set_flag_i
    @ignore_whitespace = true
  end
  
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

$flags = Flags.new
$file_name = String.new

def process_arguments
  ARGV.each do|arg|
    if arg[0] == '-' then
      $flags.send("set_flag_" + arg.slice(1..arg.length).downcase)
    else
      $file_name = arg
    end
  end
end

def run file_name, flags
  puts "processing #{file_name}"
end

process_arguments

if $file_name.length > 0 then
  run($file_name, $flags)
end


