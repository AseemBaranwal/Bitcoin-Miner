%%%-------------------------------------------------------------------
%%% @author aseem
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Sep 2022 8:23 PM
%%%-------------------------------------------------------------------
-module(server).
-author("aseem").

%% API
-export([start/0]).

generateRandomString(Length, AllowedChars)->
  lists:foldl(fun(_, Acc) ->
    [lists:nth(rand:uniform(length(AllowedChars)), AllowedChars)]
    ++ Acc
              end, [], lists:seq(1, Length)).

serverMines(K, Pid) ->
    %% Mining can take place by server
    Name = "a.baranwal;ddas1;",
    RandomString = generateRandomString(20, "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890"),
    StringToHash = Name ++ RandomString,
    Coin = io_lib:format("~64.16.0b", [binary:decode_unsigned(crypto:hash(sha256, StringToHash))]),
    ZeroString = string:left("", K, $0),
    SubString = string:substr(Coin, 1, K),
    if
      ZeroString == SubString ->
        io:fwrite("Coin Hashed : ~p Bitcoin Found : ~p from Process spawned ~p\n", [StringToHash, Coin, self()]),
        Pid ! {coinFound, self()},
        receive
          {coinRegistered} -> ok
        end
    ;true -> ok
    end,
    serverMines(K, Pid).

controlProcess(_, CoinsMined, CoinsMined) ->
  io:fwrite("Controller ~p completed work\n",[self()]),
  {_, Time1} = statistics(runtime),
  {_, Time2} = statistics(wall_clock),
  U1 = Time1 * 1000,
  U2 = Time2 * 1000,
  io:format("CPU Time = ~p microseconds, Real Time = ~p microseconds, CPU Time/Real Time = ~p\n", [U1,U2,U1/U2]),
  self() ! {terminate};

controlProcess(K, CoinsMined, CoinsRequired) ->
  receive
    {terminate} ->
      exit(self(), kill);
    {coinFound, Pid} ->
      Pid ! {coinRegistered},
      controlProcess(K, CoinsMined+1, CoinsRequired);
    {spawnProcess, Pid, SpawnNumber} ->
      lists:foreach(
        fun(_) ->
          link(spawn(fun() -> serverMines(K, Pid) end))
        end, lists:seq(1, SpawnNumber));
    {worker, Sender1} ->
      %% Establish the Connection and sending back the String and K for another miner
      Sender1 ! {K},
      io:fwrite("Received connection from ~p\n", [Sender1]);
    {worker, Sender2, StringHashed, Coin}->
      %% Mining started by the Worker
      Sender2 ! {coinRegistered},
      io:fwrite("Coin Hashed : ~p Bitcoin Found : ~p from Worker ~p\n", [StringHashed, Coin, Sender2]),
      controlProcess(K, CoinsMined+1, CoinsRequired)
  end,
  controlProcess(K, CoinsMined, CoinsRequired).

start()->
  {ok, K} = io:read("Enter number of 0s to find on the bitcoin : "),
  {ok, CoinsRequired} = io:read("Enter number of Bitcoins to be mined : "),
  {ok, SpawnNumber} = io:read("Enter number of processes to be spawned by the server : "),
  statistics(runtime),
  statistics(wall_clock),
  io:fwrite("Server starting in 3 2 1 ...\n"),
  MasterPID = spawn(fun() -> controlProcess(K, 0, CoinsRequired) end),
  MasterPID ! {spawnProcess, MasterPID, SpawnNumber},
  WorkerPID = spawn(fun() -> controlProcess(K, 0, CoinsRequired) end),
  register(server, WorkerPID).