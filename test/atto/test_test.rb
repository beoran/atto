require 'atto'
include Atto::Test

assert "Atto is defined"                        do Atto                      end
assert "Atto::Test is defined"                  do Atto::Test                end
assert "Success can be detected"                do true                      end
assert "Works with nested asserts" do
  assert "This is a nested assert"  do true end
end

assert "Works with empty description"           do assert  { true }          end

assert "Nested asserts keep the return value" do
  assert { 7 }  == 7
end

assert "Atto::Test#describe_tests is defined"   do Atto::Test.describe_tests end





