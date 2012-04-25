require File.join(File.dirname(__FILE__), 'test_helper')

class PropertyTest < Test::Unit::TestCase

  def setup
    @element = NestedCSS::Element.new
  end

  def teardown
    @element = nil
  end

  def test_add_property
    @element.update_property('color: red')
    assert_equal(1, @element.properties.count)
    assert_equal('red', @element.properties['color'])
  end

  def test_add_important_property
    @element.update_property('color: red !important')
    assert_equal(1, @element.properties.count)
  end

  def test_override_property
    @element.update_property('color: green')
    @element.update_property('color: red')
    assert_equal(1, @element.properties.count)
    assert_equal('red', @element.properties['color'])
  end

  def test_add_css_hack_property
    @element.update_property('color: green')
    @element.update_property('*color: red')
    assert_equal(2, @element.properties.count)
  end

  def test_trim_space_on_property
    @element.update_property(' color  :  red ')
    assert_equal('red', @element.properties['color'])
  end

  def test_empty_property_fails
    assert_raise ArgumentError do 
      @element.update_property(nil)
    end

    assert_raise ArgumentError do 
      @element.update_property("")
    end

    assert_raise ArgumentError do 
      @element.update_property(" ")
    end
  end

end