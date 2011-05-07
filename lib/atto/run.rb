module Atto
  # Test autorunner
  class Run
    # Shortcut to run main
    def self.main
      return self.new.main
    end
    
    # Find all Ruby all files under the named dir
    def all_files(name)
      return Dir.new(name).inject([]) do |res, e| 
        full   = File.join(name, e)
        if Dir.exist?(full) &&  e !='.' && e != '..'
          res += all_files(full)
        else
          res << full if full =~ /\.rb\Z/
        end
        res
      end
    end
    
    # updates the timestamp info for files
    def update_info(files)
      return files.inject({}) do |res, name| 
        stat      = File.stat(name)
        res[name] = Struct.new(:mtime).new(stat.mtime)
        res
      end
    end
    
    # matches libfiles wih testfiles
    def match_files(libfiles, testfiles)
      return libfiles.inject({}) do |res, libname| 
        testname = libname.dup
        where    = libname.rindex(File::Separator)
        testname[where]= File::Separator + 'test_'
        testname[File.join('','lib','')] = File.join('','test','')
        res[libname] = testname if testfiles.member?(testname)
        res
      end
    end
    
    # Runs a list of tests
    def run_tests(list)
      return list.inject({}) do |results, file|
        puts("Running tests for #{file}:")
        res = system("ruby -I #@libdir -I #@testdir #{file}")
        puts res ? "OK!" : "Failed!"
        results[file] = Time.now
        results
      end
    end
    
    # Checks if a test file must run
    def must_run(ran_tests, k, v)
      ran_tests[k] ? ran_tests[k] <= v.mtime : true
    end
    
    # updates all state info
    def update_all
      @libfiles  = all_files(@libdir)
      @testfiles = all_files(@testdir)
      @matchfiles= match_files(@libfiles, @testfiles)
      @libinfo   = update_info(@libfiles)
      @testinfo  = update_info(@testfiles)
    end
    
    # Main, runs the tests when needed
    def main
      @projdir  = ARGV[0] || Dir.pwd
      @libdir   = File.join(@projdir, ARGV[1] || 'lib')
      @testdir  = File.join(@projdir, ARGV[2] || 'test')
      update_all
      @ran_tests = run_tests(@testfiles)
      loop do
        update_all
        torun     = @testinfo.select do |k,v| 
          must_run(@ran_tests, k, v)
        end  
        extra     = @libinfo.select  do |k,v| 
          linked  = @matchfiles[k]
          linked ? must_run(@ran_tests, linked, v) : false
        end.map { |k,v| @matchfiles[k] }
        run_tests(torun.keys + extra).each { |k,v| @ran_tests[k] = v }
        sleep(1)
      end
    end
  end
end

if __FILE__ == $0
  Atto::Run.main
end