-module(parser_tests).
-include_lib("eunit/include/eunit.hrl").


extract_true_test() ->
    Json = "image\":\"src/picture.png\"",
    ?assertEqual(["src/picture.png"], parser:extract_pics(Json)).


extract_nomatch_test() ->
    Json = "rc/picture.png\"",
    ?assertEqual(failed, parser:extract_pics(Json)).


process_empty_true_test() ->
    ?assertEqual([], parser:process_links([], [])).


process_links_true_test() ->
    Json = "src/picture.png",
    Links = [[{0,3},{4,3}]],
    ?assertEqual(["sr"], parser:process_links(Json, Links)).
    