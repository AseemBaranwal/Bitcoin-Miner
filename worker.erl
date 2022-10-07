%%%-------------------------------------------------------------------
%%% @author aseem
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Sep 2022 11:17 PM
%%%-------------------------------------------------------------------
-module(worker).
-author("aseem").

%% API
-export([start/0]).

generateRandomString(Length, AllowedChars)->
  lists:foldl(fun(_, Acc) ->
    [lists:nth(rand:uniform(length(AllowedChars)), AllowedChars)]
    ++ Acc
              end, [], lists:seq(1, Length)).

mine(K, IPAddress) ->
  %% Only work till the given number of comparisons are performed
  Name = "a.baranwal;ddas1;",
  RandomString = generateRandomString(20, "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890"),
  StringHashed = Name ++ RandomString,
  Coin = io_lib:format("~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256, StringHashed))]),
  ZeroString = string:left("", K, $0),
  SubString = string:substr(Coin, 1, K),
  if
    ZeroString == SubString ->
      {server, list_to_atom(string:concat("server@",IPAddress))} ! {worker, self(), StringHashed, Coin},
      receive
        {coinRegistered} -> ok
      end
    ;true -> ok
  end,
  mine(K, IPAddress).

connectAndMine(IPAddress)->
  {server, list_to_atom(string:concat("server@",IPAddress))} ! {worker, self()},
  receive
    {K} -> mine(K, IPAddress)
  end.

start() ->
  {ok, ServerIP} = io:read("Input the server IP that you are trying to connect to : "),
  spawn(fun() -> connectAndMine(ServerIP) end).