-module(yosql).
-export([
    file/1,
    string/1
]).



file(Path) ->
    case file:read_file(Path) of
        {ok, Binary} -> string(Binary);
        Error -> Error
    end.


string(String) ->
    case yosql_lexer:string(unicode:characters_to_list(String)) of
        {ok, [], _} ->
            {ok, []};
        {ok, Tokens, _} ->
            case yosql_parser:parse(Tokens) of
                {ok, Parsed} ->
                    {ok, Parsed};
                {error, {Line, _, Details}} ->
                    {error, {Line, unicode:characters_to_list(yosql_parser:format_error(Details))}}
            end;
        {error, {Line, _, Details}, _} ->
            {error, {Line, unicode:characters_to_list(yosql_lexer:format_error(Details))}}
    end.
