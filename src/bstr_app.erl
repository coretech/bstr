%%% -*- mode: erlang;erlang-indent-level: 4;indent-tabs-mode: nil -*-
%%% ex: ts=4 sw=4 ft=erlang et indentexpr=
%%%-------------------------------------------------------------------------
%%% File:    bstr_app.erl
%%%
%%% @doc     Router API application
%%% @author  Dmitry Klionsky <dmitry.klionsky@idt.net>
%%% @since   19 Nov 2021
%%% @end
%%%-------------------------------------------------------------------------
-module('bstr_app').
-behaviour(application).

%% application callbacks.
-export([
    start/2,
    stop/1,
    config_change/3
]).

%% supervisor callbacks.
-export([
    init/1
]).


%%%------------------------------------------------------------------------
%%% Callback functions from application.
%%%------------------------------------------------------------------------

%%-------------------------------------------------------------------------
%% @spec start(Type, StartArgs) -> Result
%%           Type   = normal | {takeover, FromNode} | {failover, FromNode}
%%           Result = {ok, Pid}        |
%%                    {ok, Pid, State} |
%%                    {error, Reason}
%% @doc Start application.  StartArgs are taken from
%%      {mod, Options} option in the app file.
%% @end
%% @private
%%-------------------------------------------------------------------------
start(_Type, StartArgs) ->
    case supervisor:start_link({local, ?MODULE}, ?MODULE, StartArgs) of
    {ok, Pid} ->
        {ok, Pid, _State = []};
    ignore ->
        {error, ignore};
    {error, Error} ->
        {error, Error}
    end.

%%-------------------------------------------------------------------------
%% @spec stop(State) -> any
%% @doc Called whenever an application has stopped. The return value is
%%      ignored.
%% @end
%% @private
%%-------------------------------------------------------------------------
stop(_State) ->
    ok.

%%-------------------------------------------------------------------------
%% @spec config_change(Changed, New, Removed) -> ok
%% @doc Called by an application after a code replacement or config reload,
%%      if there are any changes to the configuration parameters.
%% @end
%% @private
%%-------------------------------------------------------------------------
config_change(_Changed, _New, _Removed) ->
    ok.

%%%------------------------------------------------------------------------
%%% Callback functions from supervisor
%%%------------------------------------------------------------------------

%%-------------------------------------------------------------------------
%% @spec init(Args) -> Result
%%           Args   = term()
%%           Result = {ok, { {RestartStrategy, MaxR, MaxT}, [ChildSpec]}} |
%%                    ignore
%%
%% @doc Called by application's supervisor to find out child specs.
%% @end
%% @private
%%-------------------------------------------------------------------------
init(_Args) ->
    {ok, {{one_for_one, 5, 15}, []}}.
