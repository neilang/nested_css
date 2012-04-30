require "nested_css/version"
require "forwardable"
require "css_parser"

module NestedCSS

  class Element
    attr_reader :children
    attr_reader :properties

    def initialize()
      @children   = Hash.new
      @properties = Hash.new
    end

    def get_or_create_element(selector)

      raise ArgumentError if selector.nil?

      selector.strip!

      raise ArgumentError if selector.empty?

      selector_parts = selector.split(/\s+/)

      element = selector_parts.shift

      if !@children.has_key?(element)
        @children[element] = Element.new
      end

      unless selector_parts.empty?
        return @children[element].get_or_create_element(selector_parts.join(' '))
      end

      return @children[element]
    end

    def update_property(property)

      raise ArgumentError if property.nil?

      property.strip!

      raise ArgumentError if property.empty?

      key, value = property.split(':', 2)
      
      @properties[key.strip] = value.strip
      
    end

    def root
      false
    end

  end

  # Represents the root element
  class Stylesheet < Element
    extend Forwardable

    def_delegators :@children, :empty?

    # The root element has no properties
    def properties
      nil
    end

    def root
      true
    end

  end

  class Parser

    attr_reader :stylesheet
    attr_accessor :indentation

    def initialize(css = nil)
      @stylesheet = nil
      self.indentation = "\t"
      self.parse_css(css) unless css.nil?
    end

    def parse_file(file)
      css_parser = CssParser::Parser.new
      css_parser.load_uri!(file)
      parse(css_parser)
    end

    def parse_css(css)
      css_parser = CssParser::Parser.new
      css_parser.add_block!(css)
      parse(css_parser)
    end

    def nested_css
      nest_css_recursively(nil, nil, -1)
    end

    private

    def parse(css_parser)

      @stylesheet = Stylesheet.new

      css_parser.each_selector(:all) do |selector, declarations, specificity|

        element = stylesheet.get_or_create_element(selector)

        declarations.split(';').each do |prop|
          next if prop.strip.empty?
          element.update_property(prop)
        end

      end
      
      # Indicate if parse was successful
      @stylesheet.empty?
    end

    def nest_css_recursively(element = nil, name = nil, depth = -1)

      # Get the root element 
      element ||= @stylesheet

      # Can't output what doesn't exist
      raise ArgumentError if element.nil?

      # Build the output
      indent        = depth >= 0 ? self.indentation * depth : ""
      nested_indent = self.indentation + indent
      output        = ""

      output += "#{indent}#{name} {\n" unless element.root

      unless element.properties.nil?
        element.properties.each_pair do |key, value|
          output += "#{nested_indent}#{key}: #{value};\n"
        end
      end

      unless element.children.nil?
        element.children.each_pair do |child_name, child|
          output += nest_css_recursively(child, child_name, depth+1)
        end
      end

      output += "#{indent}}\n" unless element.root

      output

    end

  end

end
