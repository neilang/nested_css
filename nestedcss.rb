require File.dirname(__FILE__)+'/lib/nested_css.rb'

css = ARGF.read

parser = NestedCSS::Parser.new

# remove this to switch back to tabs
parser.indentation = "  "

parser.parse(css)

puts parser.nested_css