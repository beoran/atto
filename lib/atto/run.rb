module Atto
  # Test autorunner
  class Run
    # Shortcut to run main
    def self.main
      return self.new.main
    end
    
    # Find all Ruby all files under the named dir
    def all_ruby_files(name)
      Dir["#{name}/**/*.rb"]
    end
    
    # updates the timestamp info for files
    def update_info(files)
      return files.inject({}) do |res, name| 
        stat      = File.stat(name)
        res[name] = Struct.new(:mtime).new(stat.mtime)
        res
      end
    end
    
    # matches libfiles with testfiles
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
    def run_tests(list, skip = false)
      return list.inject({}) do |results, file|
        puts(skip ? "Skipping #{file}..." : "Running tests for #{file}:") 
        unless skip
          res = system("ruby -I #@libdir -I #@testdir #{file}")
          puts res ? "OK!" : "Failed!"
        end 
        results[file] = Time.now
        results
      end
    end
    
    # Checks if a test file must run
    def must_run(ran_tests, k, v)
      ran_tests[k] ? ran_tests[k] <= v.mtime : true
    end
    
    # Updates all state info
    def update_all
      @libfiles  = all_ruby_files(@libdir)
      @testfiles = all_ruby_files(@testdir)
      @matchfiles= match_files(@libfiles, @testfiles)
      @libinfo   = update_info(@libfiles)
      @testinfo  = update_info(@testfiles)
    end
    
    # Shows help message
    def help
      warn "Usage: #{$0} OPTIONS.\nRuns unit tests in the current directory.\n"
      warn "    --help        -h      Display this help message."
      warn "    --project=dir -pdir   Sets project directory."
      warn "    --lib=sub     -lsub   Sets project library subdirectory."
      warn "    --test=sub    -tsub   Sets project test subdirectory."
      warn "    --skip        -s      Skips tests on startup.\n"
      return 0
    end
    
    # Main, runs the tests when needed
    def main
      return help if Atto::Cop.get(:help)
      @projdir  = Atto::Cop.get(:project, Dir.pwd)
      @libdir   = File.join(@projdir, Atto::Cop.get(:lib, 'lib'))
      @testdir  = File.join(@projdir, Atto::Cop.get(:test, 'test'))
      update_all
      @ran_tests = run_tests(@testfiles, Atto::Cop.get(:skip, false))
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