Definitions.

Whitespace = [\s\t]
Newline = \r?\n
Tagname = [a-z][a-z0-9_]*

Rules.

--{Whitespace}*:{Tagname}{Whitespace}+[^\r\n]*{Newline} :
    {token, {tag, TokenLine, TokenChars, tag(TokenChars)}}.

--[^\r\n]*{Newline} :
    {token, {comment, TokenLine, TokenChars}}.

{Whitespace}+ :
    {token, {whitespace, TokenLine, TokenChars}}.

[a-zA-Z0-9_.-]+ :
    {token, {word, TokenLine, TokenChars}}.

[<>=!+\-*/%^|@&#~?()\[\],]+ :
    {token, {word, TokenLine, TokenChars}}.

"([^"]|""|\")*" :
    {token, {word, TokenLine, TokenChars}}.

'([^']|''|\')*' :
    {token, {word, TokenLine, TokenChars}}.

`([^`]|``|\`)*` :
    {token, {word, TokenLine, TokenChars}}.

; :
    {token, {';', TokenLine}}.

:[a-z][a-z0-9_-]* :
    {token, {parameter, TokenLine, parameter_name(TokenChars)}}.

{Newline} :
    {token, {newline, TokenLine, TokenChars}}.


Erlang code.


tag(Content) ->
    [$-, $- | Content1] = skip_whitespace(Content),
    [$: | Content2] = skip_whitespace(Content1),
    tag_name(Content2, []).


tag_name([C | Rest], Acc) when (C >= $a andalso C =< $z) orelse (C >= $0 andalso C =< $9) orelse C =:= $_ ->
    tag_name(Rest, [C | Acc]);
tag_name([$\s | Rest], Acc) ->
    tag_value(skip_whitespace(Rest), lists:reverse(skip_whitespace(Acc)), []).


tag_value([C | _Rest], Name, Value) when C =:= $\r; C =:= $\n ->
    {Name, lists:reverse(skip_whitespace(Value))};
tag_value([C | Rest], Name, Value) ->
    tag_value(Rest, Name, [C | Value]).


parameter_name([$: | Name]) ->
    Name.


skip_whitespace([C | Rest]) when C =:= $\s; C =:= $\t ->
    skip_whitespace(Rest);
skip_whitespace(Rest) ->
    Rest.
