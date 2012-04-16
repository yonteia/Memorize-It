class Flags
  attr_reader :ignore_whitespace  
  attr_reader :annotate
  attr_reader :file_annotated
  attr_reader :cheat
  attr_reader :ignore_case
  
  ##
  ## @brief Default all flags to false at construction
  def initialize 
    @ignore_whitespace = false
    @annotate = false
    @file_annotated = false
    @cheat = false
    @ignore_case = false
  end
  
  ##
  ## @brief set the ignore_whitespace flag
  ## Tells memorize to ignore whitespace when testing if your test matches the document
  def set_flag_i
    @ignore_whitespace = true
  end
  
  def set_flag_q
    @ignore_case = true
  end
  
  ##
  ## @brief set mi for Annotate mode
  def set_flag_a
    @annotate = true
  end
  
  ##
  ## @brief tells mi that the file is annotated
  def set_flag_f
    @file_annotated = true
  end
  
  def set_flag_c
    @cheat = true
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