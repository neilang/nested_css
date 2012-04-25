require File.join(File.dirname(__FILE__), 'test_helper')

class ParserTest < Test::Unit::TestCase

  def setup
    @parser = NestedCSS::Parser.new
  end

  def teardown
    @parser = nil
  end

  def test_simple_parse
    @parser.parse("body{ color: red }")
    stylesheet = @parser.stylesheet

    assert_not_nil(stylesheet)
    assert_equal(1, stylesheet.children.count)
    assert_not_nil(stylesheet.children["body"])
  end

  def test_parse_with_comment
    @parser.parse("/* This is a comment */ body{ *color: red }")
    stylesheet = @parser.stylesheet

    assert_not_nil(stylesheet)
    assert_equal(1, stylesheet.children.count)
    assert_not_nil(stylesheet.children["body"])
  end

  def test_parse_with_comma_seperated_rules
    @parser.parse("html, body { margin:0 }")
    stylesheet = @parser.stylesheet

    assert_not_nil(stylesheet)
    assert_equal(2, stylesheet.children.count)
    assert_not_nil(stylesheet.children["html"])
    assert_not_nil(stylesheet.children["body"])
  end

  def test_parse_with_multiple_rules
    @parser.parse("html {color: red} body{ margin:0 }")
    stylesheet = @parser.stylesheet

    assert_not_nil(stylesheet)
    assert_equal(2, stylesheet.children.count)
    assert_not_nil(stylesheet.children["html"])
    assert_not_nil(stylesheet.children["body"])
  end

  def test_nested_rules
    @parser.parse("html body {color: red}")
    stylesheet = @parser.stylesheet

    assert_not_nil(stylesheet)
    assert_equal(1, stylesheet.children.count)
    assert_not_nil(stylesheet.children["html"])

    element = stylesheet.get_or_create_element("html body")
    assert_equal("red", element.properties["color"])
  end

  def test_parse_empty_rule
    @parser.parse("body {}")
    stylesheet = @parser.stylesheet

    assert_not_nil(stylesheet)
    assert_equal(1, stylesheet.children.count)
    assert_not_nil(stylesheet.children["body"])
  end

  def test_parse_empty_css
    @parser.parse("")
    stylesheet = @parser.stylesheet

    assert_not_nil(stylesheet)
    assert(stylesheet.empty?)

    @parser.parse(" ")
    stylesheet = @parser.stylesheet

    assert_not_nil(stylesheet)
    assert(stylesheet.empty?)

    @parser.parse("/* Empty */")
    stylesheet = @parser.stylesheet

    assert_not_nil(stylesheet)
    assert(stylesheet.empty?)
  end

end