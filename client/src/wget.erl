-module(wget).
-export([start/0, stop/0, test/0]).
-export([base_url/0, make_url/1, get_url_content/0, get_url_content/1]).
-compile_all([parser]).


start() -> register(pget, spawn(?MODULE, get_url_content, [])).


stop() -> unregister(pget).


base_url() -> "http://2ch.so".


test() ->
    start(),
    pget ! {thread, "http://localhost:8080/thread.html"},
    stop().


make_url(Url) ->
    binary:bin_to_list(binary:list_to_bin(re:replace(Url, ".html", ".json", [global]))).


get_url_content() ->
    receive
        {thread, Link} ->
            case get_url_content(make_url(Link)) of
                {ok, Content} ->
                    Pics = parser:extract_pics(Content),
                    tsaver ! {links, Pics},
                    get_url_content()
            end;
        _ ->
            io:format("WOK get_url_content~n", []),
            get_url_content()
    end.
get_url_content(Url) -> get_url_content(Url, 5).
get_url_content(_Url, 0) -> failed;
get_url_content(Url, MaxFailures) ->
    case httpc:request(Url) of
        {ok, {{_, RetCode, _}, _, Result}} -> if
            RetCode == 200; RetCode == 201 ->
                {ok, Result};
            RetCode == 500; RetCode == 404 ->
                io:format("wait 1000ms for ~w~n", [RetCode]),
                timer:sleep(1000),
                get_url_content(Url, MaxFailures - 1);
            true ->
                failed
            end;
        {error, _Why} ->
            io:format("wait 1000ms~n"),
            timer:sleep(1000),
            get_url_content(Url, MaxFailures - 1)
    end.