require 'atto/test'
include Atto::Test
require 'atto'

assert "Cop is defined" do
   Atto::Cop
end

# Set up some fake environent and argument options
p $0
ENV['TEST_COP_FOO'] = 'bar'
ENV['TEST_COP_BAZ'] = ""
ARGV << '--foo=quux'
ARGV << 'file1'
ARGV << '--foo=bar'
ARGV << '-fquux'
ARGV << '-fbaz'
ARGV << '--bar'
ARGV << '-b'
ARGV << 'file2'
ARGV << '--'
ARGV << '--file3'


assert "Cop is defined" do
   Atto::Cop
end

assert "Getting options from environment works" do
   res, found = Atto::Cop.get_environment(:baz)
   found
end

assert "Getting options from environment works" do
   res, found = Atto::Cop.get_environment(:foo)
   found && res == 'bar'
end

assert "Getting long command line arguments works" do
   res, found = Atto::Cop.get_argument(:foo)
   found && res == 'bar'
end

assert "Getting short command line arguments works" do
   res, found = Atto::Cop.get_arg(:foo)
   found && res == 'baz'
end

assert "Indexed command line file arguments works" do
   res, found = Atto::Cop.get_numarg(0)
   found && res == 'file1'
end

assert "Indexed command line file arguments works" do
   res, found = Atto::Cop.get_numarg(1)
   found && res == 'file2'
end

assert "Indexed command line file arguments works" do
   res, found = Atto::Cop.get_numarg(2)
   found && res == '--file3'
end

assert "Indexed command line file arguments works" do
   res, found = Atto::Cop.get_numarg(3)
   (!found) && res.nil?
end


assert "Getting generic command line arguments works" do 
   res = Atto::Cop.get(2)
   res == '--file3'
end

assert "Getting generic command line arguments works" do 
   res = Atto::Cop.get(1)   
   res == 'file2'
end

assert "Getting generic command line arguments works" do 
   res = Atto::Cop.get(0)   
   res == 'file1'
end

assert "Getting generic command line arguments works" do 
   res = Atto::Cop.get(:foo)
   res == 'bar'
end

assert "Getting generic command line arguments works" do 
   res = Atto::Cop.get(:bar)
   res == true
end

assert "Defaults work" do
   Atto::Cop.get(:kazz, 'default') == 'default' 
end

# We end here before the 100 line limit! :)
