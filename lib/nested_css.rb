require 'forwardable'

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

      # Add it to the list of children if it doesn't exist
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

      self.parse(css) unless css.nil?

    end

    def parse(css)

      @stylesheet = Stylesheet.new

      # Remove all new lines
      css = css.gsub(/[\r\n]/, '')

      # Remove all CSS comments
      css = css.gsub(/\/\*[^(\*\/)]*\*\//, '')

      css.strip!

      # Divide into individual rules using the closing brace
      rules = css.split('}')

      # Iterate through each rule to create the tree
      rules.each do |rule|

        selectors, properties = rule.split('{', 2)

        # Each rule may have multiple selector paths
        selectors.split(',').each do |selector|
          element = stylesheet.get_or_create_element(selector)

          # Apply the properties to each selector
          properties.split(';').each do |prop|
            next if prop.strip.empty?
            element.update_property(prop)
          end

        end

      end
      
      # Indicate if parse was successful
      @stylesheet.empty?
      
    end

    def nested_css(element = nil, name = nil, depth = -1)

      # Get the root element 
      element ||= @stylesheet

      # Can't output what doesn't exist
      raise ArgumentError if element.nil?

      # Build the output
      indent        = depth >= 0 ? self.indentation * depth : ""
      nested_indent = self.indentation + indent
      output        = ""

      output += "#{indent}#{name} {\n" unless name.nil?

      unless element.properties.nil?
        element.properties.each_pair do |key, value|
          output += "#{nested_indent}#{key}: #{value};\n"
        end
      end

      unless element.children.nil?
        element.children.each_pair do |child_name, child|
          output += self.nested_css(child, child_name, depth+1)
        end
      end

      output += "#{indent}}\n" unless name.nil?

      output

    end

  end

end