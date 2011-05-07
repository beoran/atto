require 'atto'
include Atto::Test

assert("Ansi is defined") { Atto::Ansi }

assert("Ansi::ATTRIBUTES  is defined") { Atto::Ansi::ATTRIBUTES }

for attr, value in Atto::Ansi::ATTRIBUTES do
  assert "Attribute #{attr} is colored correctly" do
    Atto::Ansi.color(attr) == ["\e[#{value}m", "\e[0m"]
  end
end

for attr, value in Atto::Ansi::ATTRIBUTES do
  assert "Attribute with text #{attr} is colored correctly" do
    Atto::Ansi.color(attr, "hello") == ["\e[#{value}m", "hello", "\e[0m"]
  end
end

assert "Atto::Ansi#color_string works correctly" do
  Atto::Ansi.color_string(:green, :on_yellow, "This works!") == 
  "\e[32m\e[43mThis works!\e[0m"
end

assert "Atto::Ansi#puts works correctly" do
  (Atto::Ansi.puts :green, :on_yellow, "This works!").nil?
end
