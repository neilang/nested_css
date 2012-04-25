require File.join(File.dirname(__FILE__), 'test_helper')

class OutputTest < Test::Unit::TestCase

  def setup
    @parser = NestedCSS::Parser.new
  end

  def teardown
    @parser = nil
  end

  def test_doesnt_output_empty_css

    assert_raise ArgumentError do 
      @parser.nested_css
    end
    
  end

  def test_standard_output

    @parser.parse("body{color:red}")
    nested_css = @parser.nested_css

    assert_not_nil(nested_css)
    assert(nested_css.length >= 15)
  end

  def test_nested_output
    @parser.parse("tr td{color:red}")
    nested_css = @parser.nested_css

    assert_not_nil(nested_css)
    assert_not_nil(nested_css.match(/tr\s*{\s*td/))
  end

end