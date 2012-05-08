-module(client).
-export([start/0, stop/0, restart/0, load/1]).
-compile_all([saver, wget, parser]).

start() ->
    inets:start(),
    saver:start(),
    wget:start().

stop() ->
    inets:stop(),
    saver:stop(),
    wget:stop().

restart() ->
    inets:stop(),
    saver:stop(),
    wget:stop(),
    inets:start(),
    saver:start(),
    wget:start(),
    ok.

load(Link) ->
    pget ! {thread, Link}.