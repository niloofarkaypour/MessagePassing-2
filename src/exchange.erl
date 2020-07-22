%%%-------------------------------------------------------------------
%%% @author Niloofar
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Jun 2020 11:07 AM
%%%-------------------------------------------------------------------
-module(exchange).
-author("Niloofar").

-export([start/0]).

start()->
  io: fwrite("** Calls to be made **\n"),
  {ok, File} = file:consult("C:/Users/Niloofar/IdeaProjects/Java-COMP6411/src/calls.txt"),

  register(master, self()),

  lists:foreach(fun(CallingList) ->
    Person = element(1, CallingList),
    FriendsList = element(2, CallingList),
    io:fwrite(Person),
    io:fwrite("~p~n",[FriendsList]),
    Pid = spawn(calling, callPassing, [Person, FriendsList]),
    register(Person, Pid)

                end,
    File
  ),
  io:fwrite("~n"),
  receiving().


receiving()->
  receive

  {Person, Sender, TimeStamp} ->
      io:format("~p received intro message from ~p (~p) ~n",[Person,Sender,TimeStamp]),
      receiving();

    {Person, Sender, TimeStamp, Respond} ->
      io: format("~p received reply message from ~p (~p) ~n",[Person, Sender, TimeStamp]),
      receiving();

    {Person} ->
      io:format("Process ~p has received no calls for 5 second, ending...~n", [Person]),
      receiving()

  after (10000) ->
    io:format("Master has received no replies for 10 seconds, ending...~n")

  end.

