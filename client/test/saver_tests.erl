-module(saver_tests).
-include_lib("eunit/include/eunit.hrl").


base_url_test() ->
    ?assertEqual("http://localhost:8080/", saver:base_url()).


url_to_path_test() ->
    Url = saver:url_to_path("src/12345.png"),
    ?assertEqual("./pics/12345.png", Url).

start_test() ->
    ?assertEqual(ok, saver:start()),
    saver:stop().

stop_test() ->
    saver:start(),
    ?assertEqual(ok, saver:stop()).