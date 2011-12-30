CSS::SCSS
  ->parse_string
  ->parse_file

  + parser
  + content[] : CSS::SCSS::Block


CSS::SCSS::Block
  + parent : CSS::SCSS::Block
  + selector : CSS::SCSS::Selector
  + media : Str
  + rules[] : CSS::SCSS::Rule
  + variable{}
  ->as_string



      |
      |
      +- CSS::SCSS::Rule
      |    |
      |    +- CSS::SCSS::Selector
      |    |
      |    +- CSS::SCSS::Declaration
      |
      +- CSS::SCSS::Comment

