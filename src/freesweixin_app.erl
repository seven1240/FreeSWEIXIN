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
	application:start(freesweixin).

start(_StartType, _StartArgs) ->
	?LOG(info, "starting", []),
    freesweixin_sup:start_link().

stop(_State) ->
    ok.
