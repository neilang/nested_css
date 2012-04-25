require File.join(File.dirname(__FILE__), 'test_helper')

class StylesheetTest < Test::Unit::TestCase

  def setup
    @stylesheet = NestedCSS::Stylesheet.new
  end

  def teardown
    @stylesheet = nil
  end

  def test_cant_add_properties
    @stylesheet.update_property('color: red')
    assert_nil(@stylesheet.properties)
  end

  def test_can_add_elements
    @stylesheet.get_or_create_element('body')
    assert_not_equal(0, @stylesheet.children.count)
  end

end