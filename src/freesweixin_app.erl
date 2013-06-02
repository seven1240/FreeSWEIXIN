-module(freesweixin_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1]).

-include("global.hrl").

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
	application:start(cowboy),
	Dispatch = [
	    %% {Host, list({Path, Handler, Opts})}
	    {'_', [{[<<"weixin">>], web_weixin_handler, []}]},
	    {'_', [{'_', web_default_handler, []}]}
	],
	%% Name, NbAcceptors, Transport, TransOpts, Protocol, ProtoOpts
	cowboy:start_listener(my_http_listener, 100,
	    cowboy_tcp_transport, [{port, 8088}],
	    cowboy_http_protocol, [{dispatch, Dispatch}]
	),

	application:start(freesweixin).

start(_StartType, _StartArgs) ->
	?LOG(info, "starting", []),
    freesweixin_sup:start_link().

stop(_State) ->
    ok.
