-module(parser).
-export([extract_pics/1]).


extract_pics(Json) ->
    case re:run(Json, "src/(.*?)\"", [global]) of
        {match, Links} ->
            process_links(Json, Links);
        nomatch -> failed
    end.


process_links(_Json, []) -> [];
process_links(Json, [Link | Links]) ->
    [From, _] = Link,
    {Start, End} = From,
    [string:substr(Json, Start + 1, End - 1) | process_links(Json, Links)].