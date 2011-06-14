module Atto  
  # Cop is a module for commandline (and environment) options
  module Cop

    # Gets an option from the environment. The key will be uppercased, prepended 
    # by the uppercase basename of $0 without extension and _, and any spaces, 
    # dashes will be replaced by underscores. Returns the value found, or 
    # default if not found, and a boolean that indicates if the key was found 
    # or not found.
    def get_environment(key, default= nil)
      base   = File.basename($0).gsub(/\..*\Z/,'').upcase + "_"
      envkey = base + key.to_s.upcase.gsub('[ \.\-]', '_')
      res    = ENV[envkey]
      if res
        return res, true
      end
      return default, false
    end
    
    # Gets a command line argument from ARGV, on condition that it is not
    # a --command, or preceded by a -c style option. It recognizes -- also.
    def get_numarg(num, default=nil)
      numkey = num.to_i
      skip , aid, index = true, [], 0
      while index < ARGV.size
        arg    = ARGV[index]
        if arg == '--'
          skip = false
        elsif (arg[0..1] == '--') && skip
        elsif arg[0] == '-' && skip
        else 
          aid << arg
        end
        index += 1
      end
      return aid[num], true if aid[num] 
      return default, false 
    end
    
    # Gets a long --foo=bar style commandline argument from ARGV. The key will
    # be lowercased, prepended with -- and any spaces, periods or underscores 
    # will be replaced by dashes. Returns the value found, or default if not 
    # found, and a boolean that indicates if the key was found or not found.
    def get_argument(key, default=nil)
      argkey = "--" + key.to_s.downcase.gsub('[ \.\_]', '-')
      res    = ARGV.reverse.find{ |arg| arg =~ /\A#{argkey}(\Z|=)/ } 
      return default, false unless res
      index  = res.index('=')
      return true, true unless index
      return res[index + 1, res.size] , true
    end
    
    # Gets a long -cbar style commandline argument from ARGV. The first 
    # character of key will be taken, lowercased, and prepended with -
    # Returns the value found, or default if not found, and 
    # a boolean that indicates if the key was found or not found.
    def get_arg(key, default=nil)
      argkey = "-" + key.to_s[0].downcase
      res    = ARGV.reverse.find{ |arg| arg =~ /\A#{argkey}/ }
      return default, false unless res
      if res.size == 2
        return true, true
      end         
      return res[2, res.size] , true
    end
      
    def get(key, default=nil)
      if key.respond_to?(:to_int)
        res, found = get_numarg(key, default)
        return res if found
      end   
      res, found = get_argument(key, default)
      return res if found  
      res, found = get_arg(key, default)
      return res if found 
      res, found = get_environment(key, default)
      return res if found
      return default  
    end
    
    def [](key)
      return get(key, nil)
    end
    
    extend self
  end
end  
  