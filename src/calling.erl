%%%-------------------------------------------------------------------
%%% @author Niloofar
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Jun 2020 6:03 PM
%%%-------------------------------------------------------------------
-module(calling).
-author("Niloofar").

-export([callPassing/2]).

callPassing(Person, FriendsList)->
  SequentialCall = fun(Per) ->
    sending(Person, Per)
                   end,
  lists:foreach(SequentialCall, FriendsList),
  receiving(Person).

sending(Person, CallingList)->
  timer:sleep(random:uniform(100)),
  TimeStamp = element(3, now()),
  FriendsListId = whereis(CallingList),
  FriendsListId ! { Person, TimeStamp }.

receiving(Person)->
  receive
    { Sender, TimeStamp } ->
      MasterId = whereis(master),
      MasterId ! { Person, Sender, TimeStamp },
      RespondId = whereis(Sender),
      RespondId ! { Person, TimeStamp, 1 },
      receiving(Person);

    { Sender, TimeStamp, Respond } ->
      MasterId = whereis(master),
      MasterId ! { Person, Sender, TimeStamp, Respond },
      receiving(Person)

  after (5000) ->
    MasterId = whereis(master),
    MasterId ! { Person }

  end.