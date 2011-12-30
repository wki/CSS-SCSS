package CSS::SCSS::Parser::Grammar;
use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(css_grammar);

sub css_grammar {
    return {
        start => 'css',
        actions => 'CSS::SCSS::Parser::Action',
        default_action => 'do_default',
        terminals => [qw(
            OPEN_CURLY CLOSE_CURLY OPEN_PAREN CLOSE_PAREN OPEN_BRACKET CLOSE_BRACKET
            SPACE SEMICOLON COLON COMMA SPLASH SLASH DOT HASH ATTR_CMP GT PLUS MINUS
            DOLLAR AMPERSAND
            STRING IDENT HEXCOLOR NUMBER
            AT_CHARSET AT_IMPORT AT_MEDIA AT_PAGE IMPORTANT
        )],
        rules => [
            {
                lhs => 'css',
                rhs => [qw(optional_space charset
                           optional_space imports
                           optional_space css_content
                           optional_space)],
            },
            
            { lhs => 'charset' },
            { lhs => 'charset', rhs => [qw(AT_CHARSET STRING SEMICOLON)] },
            
            { lhs => 'imports' },
            { 
                lhs => 'imports',
                rhs => [qw(AT_IMPORT expression SEMICOLON)],
            },
            
            { lhs => 'css_content', rhs => ['css_content_part'], min => 0 },
            
            { lhs => 'css_content_part', rhs => [qw(ruleset)], },
            { lhs => 'css_content_part', rhs => [qw(media)] },
            { lhs => 'css_content_part', rhs => [qw(page)] },
            { lhs => 'css_content_part', rhs => [qw(variable_definition)] },
            
            { 
                lhs => 'ruleset',
                rhs => [qw(optional_space selectors
                           optional_space OPEN_CURLY 
                           optional_space declarations 
                           optional_space CLOSE_CURLY)],
            },
            
            { lhs => 'declarations' },
            { lhs => 'declarations', rhs => [qw(variable_definition declarations)], },
            { lhs => 'declarations', rhs => [qw(ruleset declarations)], },
            { lhs => 'declarations', rhs => [qw(declaration optional_space SEMICOLON declarations)], },
            { lhs => 'declarations', rhs => [qw(declaration)] },
            
            
            { 
                lhs => 'declaration', 
                rhs => [qw(optional_space property
                           optional_space COLON
                           optional_space expression
                           optional_space prio)] },
            
            { lhs => 'prio', rhs => [qw(IMPORTANT)], action => 'important' },
            { lhs => 'prio' },
            
            { lhs => 'selectors', rhs => [qw(selector COMMA optional_space selectors)] },
            { lhs => 'selectors', rhs => [qw(selector)] },
            
            { lhs => 'selector', rhs => [qw(element specializers)] },
            { lhs => 'selector', rhs => [qw(specializer)], min => 1 },
            { lhs => 'selector', rhs => [qw(selector divider selector)] },
            
            { lhs => 'element', rhs => [qw(IDENT)] },
            { lhs => 'element', rhs => [qw(SPLASH)] },
            { lhs => 'element', rhs => [qw(AMPERSAND)] },
            
            { lhs => 'divider', rhs => [qw(SPACE)] },
            { lhs => 'divider', rhs => [qw(GT)] },
            { lhs => 'divider', rhs => [qw(PLUS)] },
            
            { lhs => 'specializers', rhs => [qw(specializer)], min => 0 },
            
            { lhs => 'specializer', rhs => [qw(DOT IDENT)] },
            { lhs => 'specializer', rhs => [qw(HASH IDENT)] },
            { lhs => 'specializer', rhs => [qw(COLON ident_or_function)] },
            { lhs => 'specializer', rhs => [qw(OPEN_BRACKET attribute CLOSE_BRACKET)] },
            
            { lhs => 'attribute', rhs => [qw(IDENT)] },
            { lhs => 'attribute', rhs => [qw(IDENT ATTR_CMP ident_or_string)] },
            
            { lhs => 'property', rhs => [qw(expression)] },
            
            { lhs => 'media', rhs => [qw(AT_MEDIA idents OPEN_CURLY ruleset CLOSE_CURLY)] },
                      
            { lhs => 'page', rhs => [qw(AT_PAGE pseudo_page OPEN_CURLY declarations CLOSE_CURLY)] },
            
            { lhs => 'pseudo_page', rhs => [qw(COLON idents)] },
            { lhs => 'pseudo_page' },
            
            { lhs => 'variable_definition', rhs => [qw(optional_space DOLLAR IDENT 
                                                       optional_space COLON expression 
                                                       optional_space SEMICOLON)]},
            
            { lhs => 'expression', rhs => [qw(expr)] },
            { lhs => 'expression', rhs => [qw(expr expr_op expression)] },
            
            { lhs => 'expr_op', rhs => [qw(SPACE)] },
            { lhs => 'expr_op', rhs => [qw(optional_space COMMA optional_space)] },
            { lhs => 'expr_op', rhs => [qw(optional_space SLASH optional_space)] },   ### FIXME: conflict with "/" factor_op
            
            { lhs => 'expr', rhs => [qw(term)] },
            { lhs => 'expr', rhs => [qw(optional_term_op term term_op expr)] },
            
            { lhs => 'optional_term_op' },
            { lhs => 'optional_term_op', rhs => [qw(term_op)] },
            
            { lhs => 'term_op', rhs => [qw(PLUS)] },
            { lhs => 'term_op', rhs => [qw(MINUS)] },
            
            { lhs => 'term', rhs => [qw(factor)] },
            { lhs => 'term', rhs => [qw(factor factor_op term)] },
            
            { lhs => 'factor_op', rhs => [qw(SPLASH)] },
            { lhs => 'factor_op', rhs => [qw(SLASH)] },   ### FIXME: conflict with "/" expr_op
            
            { lhs => 'factor', rhs => [qw(STRING)] },
            { lhs => 'factor', rhs => [qw(NUMBER)] },
            { lhs => 'factor', rhs => [qw(IDENT)] },
            { lhs => 'factor', rhs => [qw(HEXCOLOR)] },
            { lhs => 'factor', rhs => [qw(function_call)] },
            { lhs => 'factor', rhs => [qw(variable)] },
            { lhs => 'factor', rhs => [qw(OPEN_PAREN expression CLOSE_PAREN)] },
            
            { lhs => 'variable', rhs => [qw(DOLLAR IDENT)] },
            
            { lhs => 'ident_or_string', rhs => [qw(IDENT)] },
            { lhs => 'ident_or_string', rhs => [qw(STRING)] },
                      
            { lhs => 'ident_or_function', rhs => [qw(IDENT)] },
            { lhs => 'ident_or_function', rhs => [qw(function_call)] },
            
            { lhs => 'idents', rhs => [qw(IDENT)] },
            { lhs => 'idents', rhs => [qw(IDENT COMMA idents)] },
            
            { lhs => 'function_call', rhs => [qw(IDENT OPEN_PAREN expression CLOSE_PAREN)] },
            
            { lhs => 'optional_space', rhs => [qw(SPACE)], min => 0 },
            
            # # identifier with interpolation
            # { lhs => 'ident', rhs => [qw(ident_part)], min => 1 },
            # 
            # { lhs => 'ident_part', rhs => [qw(LETTER)] },
            # { lhs => 'ident_part', rhs => [qw(DIGIT)] },
            # { lhs => 'ident_part', rhs => [qw(MINUS)] },
            # { lhs => 'ident_part', rhs => [qw(interpolation)] },
            
            # string with interpolation
        ],
    };
}

1;
