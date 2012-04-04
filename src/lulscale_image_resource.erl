-module(lulscale_image_resource).
-export([
         init/1,
         allowed_methods/2,
         content_types_provided/2,
         ship_image/2
]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, no_state}.

allowed_methods(RequestData, Ctx) ->
     {['GET'], RequestData, Ctx}.

content_types_provided(RequestData, Ctx) ->
    {[
      {"image/png",  ship_image },
      {"image/jpg",  ship_image },
      {"image/gif",  ship_image },
      {"image/jpeg", ship_image }
     ], RequestData, Ctx}.

ship_image(RequestData, Ctx) ->
    FileName = wrq:disp_path(RequestData),
    StorePath = filename:join(["/tmp/e/", FileName]),
    case file:read_file(StorePath) of
        {ok, File} ->
            {File, RequestData, Ctx};
        {error, Reason} ->
            erlang:error(Reason)
    end.
