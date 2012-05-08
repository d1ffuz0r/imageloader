-module(wget_tests).
-include_lib("eunit/include/eunit.hrl").


base_url_test() ->
    ?assertEqual("http://2ch.so", wget:base_url()).


start_test() ->
    ?assertEqual(ok, wget:start()),
    wget:stop().


stop_test() ->
    wget:start(),
    ?assertEqual(ok, wget:stop()).

malke_url_true_test() ->
    Url = "http://localhost:8080/thread.html",
    ?assertEqual("http://localhost:8080/thread.json",
        wget:make_url(Url)).
