require File.join(File.dirname(__FILE__), 'test_helper')

class ElementTest < Test::Unit::TestCase
  
  def setup
    @stylesheet = NestedCSS::Stylesheet.new
  end

  def teardown
    @stylesheet = nil
  end

  def test_add_new_element
    element = @stylesheet.get_or_create_element('body')
    assert_not_nil(element)
    assert_equal(@stylesheet.children['body'], element)
  end

  def test_add_nested_element
    element = @stylesheet.get_or_create_element('body p')
    assert_not_nil(element)
    assert_not_equal(@stylesheet.children['body'], element)

    body = @stylesheet.get_or_create_element('body')
    assert_not_nil(body)
    assert_equal(element, body.children['p'])
  end

  def test_add_same_selector
    e1 = @stylesheet.get_or_create_element('body')
    e2 = @stylesheet.get_or_create_element('body')
    assert_equal(1, @stylesheet.children.count)
    assert_equal(e1, e2)
  end

  def test_add_siblings
    e1 = @stylesheet.get_or_create_element('body')
    e2 = @stylesheet.get_or_create_element('div')
    assert_equal(2, @stylesheet.children.count)
    assert_not_equal(e1, e2)
  end

  def test_add_nested_siblings
    e1 = @stylesheet.get_or_create_element('body section')
    e2 = @stylesheet.get_or_create_element('body aside')
    assert_equal(1, @stylesheet.children.count)
    assert_equal(2, @stylesheet.children['body'].children.count)
    assert_not_equal(e1, e2)
  end

  def test_empty_selectors_fail
    assert_raise ArgumentError do 
      @stylesheet.get_or_create_element(nil)
    end

    assert_raise ArgumentError do 
      @stylesheet.get_or_create_element("")
    end

    assert_raise ArgumentError do 
      @stylesheet.get_or_create_element(" ")
    end
  end

  def test_nested_selectors_dont_collide
    e1 = @stylesheet.get_or_create_element('p')
    e2 = @stylesheet.get_or_create_element('body p')

    assert_equal(2, @stylesheet.children.count)
    assert_not_equal(e1, e2)
  end

end