CSS::SCSS
  ->parse_string
  ->parse_file

  + parser
  + content (== CSS::SCSS::Block)
      |
      +- CSS::SCSS::Rule
      |    |
      |    +- CSS::SCSS::Selector
      |    |
      |    +- CSS::SCSS::Declaration
      |
      +- CSS::SCSS::Comment

