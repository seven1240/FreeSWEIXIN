
-module(freesweixin_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
	Dispatch = [
	    %% {Host, list({Path, Handler, Opts})}
	    {'_', [
			{[<<"weixin">>], web_weixin_handler, []},
			{'_', web_default_handler, []}
	    ]},
	    {'_', [{'_', web_default_handler, []}]}
	],

	{ok, Port} = application:get_env(freesweixin, http_port),
	% Port = 8078,

	%% Name, NbAcceptors, Transport, TransOpts, Protocol, ProtoOpts
	cowboy:start_listener(my_http_listener, 100,
	    cowboy_tcp_transport, [{port, Port}],
	    cowboy_http_protocol, [{dispatch, Dispatch}]
	),

    {ok, { {one_for_one, 5, 10}, []} }.

