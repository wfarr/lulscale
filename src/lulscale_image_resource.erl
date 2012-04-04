-module(lulscale_image_resource).
-export([
         init/1,
         allowed_methods/2,
         content_types_provided/2,
         to_html/2,
         img_stream/2
]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, no_state}.

allowed_methods(RequestData, Ctx) ->
     {['GET'], RequestData, Ctx}.

content_types_provided(RequestData, Ctx) ->
    {[
      {"image/png",  img_stream },
      {"image/jpg",  img_stream },
      {"image/gif",  img_stream },
      {"image/jpeg", img_stream }
     ], RequestData, Ctx}.

to_html(RequestData, Ctx) ->
    {"<html><body>Foo</body></html", RequestData, Ctx}.

img_stream(RequestData, Ctx) ->
    FileName = wrq:disp_path(RequestData),
    StorePath = filename:join(["/tmp/e/", FileName]),
    case file:read_file(StorePath) of
        {ok, File} ->
            {File, RequestData, Ctx};
        {error, Reason} ->
            erlang:error(StorePath)
    end.
