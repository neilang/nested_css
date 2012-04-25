Nested CSS
==========

A proof of concept script to convert traditional CSS into the nested selector form used in LESS and SCSS/SASS.


Instructions
------

Once you download the repository you can use the ruby or bash script  in the base directory to generate nested CSS from a regular CSS file or standard in.

e.g.

    nestedcss ~/filename.css

Or

    cat filename.css | nestedcss



Caveats
-------

Currently won't work with: 

  * CSS imports
  * Media Queries
