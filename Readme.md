Nested CSS
==========

A proof of concept gem to convert traditional CSS into the nested selector form used in LESS and SCSS/SASS.

How it works
------------

It will convert a standard set of CSS instructions from this:

```CSS
nav{ background-color:#FFF; }
nav ul{ text-align:right;}
nav ul li a{ display:block; padding:0.3em 1em 0.2em; }
```

to a nested form like this:

```CSS
nav {
  background-color: #FFF;
  ul {
    text-align: right;
    li {
      a {
        padding: 0.3em 1em 0.2em;
        display: block;
      }
    }
  }
}
```

Instructions
------------


You can install by typing:

    git clone git@github.com:neilang/nested_css.git
    cd nested_css
    bundle install
    rake build
    rake install


You can now transform a css file like so: 

    nested_css ~/Desktop/my_file.css

Or from a remote file:

    nested_css http://example.com/styles/main.css

You can also set the indentation style via string (default is tabs):

For two spaces instead of tabs:

    nested_css --indent "  " ~/Desktop/my_file.css
    

Caveats
-------

CSS rules will be re-ordered when parsed. Media queries are not currently supported. 
