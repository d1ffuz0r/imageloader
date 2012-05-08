-module(saver).
-export([start/0, base_url/0, stop/0, test/0, save_loop/0]).
-compile_all([wget]).


start() -> register(tsaver, spawn(?MODULE, save_loop, [])).
stop() -> unregister(tsaver).


base_url() -> "http://localhost:8080/".


url_to_path(Url) ->
    "./pics/" ++ string:substr(Url, 5, length(Url)).


download(Parent, Url) ->
    case wget:get_url_content(saver:base_url() ++ Url) of
        {ok, Data} ->
            io:format("load ~s~n", [Url]),
        file:write_file(url_to_path(Url), Data)
    end,
    Parent ! done.


test() ->
    start(),
    tsaver ! {links, ["one", "two", "three"]},
    stop().


save_loop() ->
    receive
        {links, Links} ->
            save_loop(0, Links);
        _ ->
            io:format("WOK save_loop~n"),
            save_loop()
    end.
save_loop(0, []) ->
    io:format("saving done~n", []),
    save_loop();
save_loop(Running, []) ->
    receive
        done ->
            io:format("to save ~w~n", [Running]),
            save_loop(Running - 1, [])
    end;

save_loop(Running, [Pic | Pics]) when Running < 10 ->
    S = self(),
    spawn(fun() -> download(S, Pic) end),
    save_loop(Running + 1, Pics);

save_loop(Running, Pics) ->
    receive
        done ->
            io:format("to save: ~p~n", [Running + length(Pics)]),
            save_loop(Running - 1, Pics)
    end.