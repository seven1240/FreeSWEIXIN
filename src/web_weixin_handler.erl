-module(web_weixin_handler).
-author("Du Jinfang <dujinfang@gmail.com>").
-behaviour(cowboy_http_handler).
-export([init/3, handle/2, terminate/2]).

-include_lib("xmerl/include/xmerl.hrl").
-include("global.hrl").

init({_Any, http}, Req, []) ->
	{ok, Req, []}.

handle(Req, State) ->
	case cowboy_http_req:method(Req) of
		{'GET', Req} ->
			handle_get(Req, State);
		{'POST', Req} ->
			handle_post(Req, State)
	end.


terminate(_Req, _State) ->
	ok.


%% private

handle_get(Req, State) ->
	{Signature, _} = cowboy_http_req:qs_val(<<"signature">>, Req),
	{Timestamp, _} = cowboy_http_req:qs_val(<<"timestamp">>, Req),
	{Nonce, _}     = cowboy_http_req:qs_val(<<"nonce">>, Req),
	{EchoStr, _}   = cowboy_http_req:qs_val(<<"echostr">>, Req),

	{ok, Token} = application:get_env(freesweixin, token),

	Str = [Token, Timestamp, Nonce],
	Sorted = bjoin(lists:sort(Str)),
	SHA = crypto:sha(Sorted),
	io:format("~p ~p~n", [Sorted, SHA]),
	?LOG(info, "s:~s, t:~s, n:~s, e:~s", [Signature, Timestamp, Nonce, EchoStr]),

	SHAstr = io_lib:format(
		"~2.16.0b~2.16.0b~2.16.0b~2.16.0b~2.16.0b~2.16.0b~2.16.0b~2.16.0b~2.16.0b~2.16.0b"
		"~2.16.0b~2.16.0b~2.16.0b~2.16.0b~2.16.0b~2.16.0b~2.16.0b~2.16.0b~2.16.0b~2.16.0b",
		binary_to_list(SHA)),

	case iolist_to_binary(SHAstr) of
		Signature ->
			{Peer, _} = cowboy_http_req:peer_addr(Req),
			?LOG(debug, "peer:~p", [Peer]),
			{ok, Req3} = cowboy_http_req:reply(200, [], EchoStr, Req);
		_ ->
			?LOG(warning, "~p~n~p", [iolist_to_binary(SHAstr), Signature]),
			{ok, Req3} = cowboy_http_req:reply(500, [], <<"Error">>, Req)
	end,

	{ok, Req3, State}.

handle_post(Req, State) ->
	{ok, Body, _} = cowboy_http_req:body(Req),
	{Doc, _} = xmerl_scan:string(binary_to_list(Body)),

	?LOG(debug, "~p", [Body]),

	ToUserName = get_xml_text("ToUserName", Doc),
	FromUserName = get_xml_text("FromUserName", Doc),
	CreateTime = get_xml_text("CreateTime", Doc),
	MsgType = get_xml_text("MsgType", Doc),
	Content = get_xml_text("Content", Doc),
	MsgId = get_xml_text("MsgId", Doc),

	{Peer, _} = cowboy_http_req:peer_addr(Req),
	?LOG(debug, "peer:~p", [Peer]),

	?LOG(debug, "to:~p from:~p ct:~p mt:~p mid:~p~n~p",
		[ToUserName, FromUserName, CreateTime, MsgType, MsgId, Content]),

	Content1 = "We have received your text, 3ks!",

Response = io_lib:format(
"<xml>
<ToUserName><![CDATA[~s]]></ToUserName>
<FromUserName><![CDATA[~s]]></FromUserName>
<CreateTime>~s</CreateTime>
<MsgType><![CDATA[text]]></MsgType>
<Content><![CDATA[~s]]></Content>
<FuncFlag>0</FuncFlag>
</xml>",
[FromUserName, ToUserName, CreateTime, Content1]),


	{ok, Req2} = cowboy_http_req:reply(200, [], Response, Req),
	{ok, Req2, State}.


bjoin(List) ->
    F = fun(A, B) -> <<A/binary, B/binary>> end,
    lists:foldr(F, <<>>, List).

get_xml_text(Tag, Doc) ->
	get_xml_text_xpath("/xml/" ++ Tag ++ "/text()", Doc).

get_xml_text_xpath(XPath, Doc) ->
	case xmerl_xpath:string(XPath, Doc) of
		[E] when is_record(E, xmlText) -> E#xmlText.value;
		_ -> undefined
	end.
