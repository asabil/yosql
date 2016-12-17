Nonterminals
queries query comments tags statement statement_body.

Terminals
whitespace comment newline tag word parameter ';'.

Rootsymbol
queries.


queries -> '$empty'                         : [].
queries -> query queries                    : ['$1' | '$2'].

query -> comments tags statement            : {tags('$2'), statement('$3')}.

comments -> '$empty'                        : [].
comments -> comment comments                : ['$1' | '$2'].
comments -> newline comments                : '$2'.

tags -> '$empty'                            : [].
tags -> tag tags                            : [tag('$1') | '$2'].

statement -> statement_body ';' comments    : '$1'.

statement_body -> '$empty'                  : [].
statement_body -> word statement_body       : [value_of('$1') | '$2'].
statement_body -> whitespace statement_body : [$\s | '$2'].
statement_body -> newline statement_body    : [$\s | '$2'].
statement_body -> comment statement_body    : '$2'.
statement_body -> tag statement_body        : '$2'.
statement_body -> parameter statement_body  : [{param, value_of('$1')} | '$2'].


Erlang code.


tags(Pairs) ->
    maps:from_list(Pairs).


statement(Statement) ->
    lists:flatten(Statement).


tag(Token) ->
    element(4, Token).


value_of(Token) ->
    element(3, Token).
