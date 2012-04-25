Nested CSS
==========

A proof of concept script to convert traditional CSS into the nested selector form used in LESS and SCSS/SASS.

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
------

Once you download the repository you can use the ruby or bash script  in the base directory to generate nested CSS from a regular CSS file or STDIN.

e.g.

    nestedcss ~/filename.css

Or

    cat filename.css | nestedcss



Caveats
-------

Currently won't work with: 

  * CSS imports
  * Media Queries
