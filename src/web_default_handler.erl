-module(web_default_handler).
-author("Du Jinfang <dujinfang@gmail.com>").
-behaviour(cowboy_http_handler).
-export([init/3, handle/2, terminate/2]).

-include("global.hrl").

init({_Any, http}, Req, []) ->
	{ok, Req, []}.

handle(Req, State) ->
	{ok, Req3} = cowboy_http_req:reply(200, [], <<"Welcome">>, Req),
	{ok, Req3, State}.

terminate(_Req, _State) ->
	ok.
