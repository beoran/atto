# Atto is a tiny KISS library full of useful functionality for TDD and BDD.
module Atto
  # Ansi colors for red/green display after testing.
  autoload :Ansi, 'atto/ansi'
  # Testing
  autoload :Test, 'atto/test'
  # Autorunning tests
  autoload :Run, 'atto/run'
end 