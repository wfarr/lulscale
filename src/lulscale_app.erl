%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Callbacks for the lulscale application.

-module(lulscale_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for lulscale.
start(_Type, _StartArgs) ->
    lulscale_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for lulscale.
stop(_State) ->
    ok.
