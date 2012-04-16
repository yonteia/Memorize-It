class Read
  ## 
  ## @brief Initialize the script reader
  ## TODO process a setup file to define these parameters so this application can be used with other scripts
  def initialize
    @@default_volume = 50 # volume as a percentage
    @@default_rate = 0
    @line_read = {
      /^NICKIE:/ => { # NICKI: lines
        :volume => 100, # volume of NICKIE: lines 
        :rate => 0
        }, 
      /^TERRY:/ => { # TERRY: lines
        :volume => 75, # volume of TERRY: lines 
        :rate => 0
        },            
      /^./ => { # other lines
        :volume => @@default_volume, # volume of other lines 
        :rate => 0  # rate of other lines
        } 
      }
     @continuation = /^\s/
     @last_read = { # the parameters for the last read 
       :volume => @@default_volume,
       :rate => @@default_volume
     }    
  end
  
  ##
  ## @brief Run the ptts command
  ## @param volume The volume to read the text at
  ## @param rate How fast to read the line
  ## #param text The text to read 
  def ptts volume, rate, text
    # clean up line
    text.gsub! /[^A-Za-z0-9\.!\?\-\'\(\):,]/, ' '
    
    # hack to supply input to ptts 
    file = File.new "out_to_in.txt", "w"
    file.puts text 
    file.close
    file = nil
    
    # display what is being executed and read
    cmd = "\"C:\\Program Files\\Jampal\\ptts.exe\" -r #{rate} -v #{volume} -u out_to_in.txt"
    puts text
    puts cmd
    
    # execute command (will return false if the command is interupted with a ctrl-c, true otherwise)
    system cmd 
  end
  
  def read_parsed_lines file_name    
    (File.new file_name, "r").each do |line|
      if line.chomp.empty? then
        next
      end

      if line.match @continuation then
        if ptts @last_read[:volume], @last_read[:rate], line then
          next
        else
          exit
        end
      end
      
      # find what volume to read the line at
      @line_read.each do |tag, param|
        if line.match tag then 
          if ptts param[:volume], param[:rate], line then
            @last_read = param
            break # we read a line, time to move on to the next one
          else
            exit # execution was interrupted, exit program
          end            
        end 
      end
    end
  end
end

if ARGV.length > 0 then
  Read.new.read_parsed_lines(ARGV[0])
end
