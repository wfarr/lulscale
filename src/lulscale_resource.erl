%% pretty much all of this code by argv0:
%% https://bitbucket.org/argv0/webmachine_examples/src/eeac8c49a47d/fileupload/src/fileupload_resource.erl

-module(lulscale_resource).
-export([init/1,
         to_html/2,
         allowed_methods/2,
         process_post/2,
         allow_missing_post/2
        ]).
-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, no_state}.

allowed_methods(RequestData, Ctx) -> {['GET', 'POST'], RequestData, Ctx}.

allow_missing_post(RequestData, Ctx) -> false.

process_post(RequestData, Ctx) ->
    ContentType = wrq:get_req_header("content-type", RequestData),
    Boundary = string:substr(ContentType, string:str(ContentType, "boundary=") 
                             + length("boundary=")),
    {FileName, FileSize, Content} = get_streamed_body(
                                      webmachine_multipart:stream_parts(
                                        wrq:stream_req_body(RequestData, 1024), 
                                        Boundary), [],[]),
    StorePath = filename:join(["/tmp/e/", FileName]),
    filelib:ensure_dir(StorePath),
    file:write_file(StorePath, Content),
    NewRequestData = wrq:do_redirect(true,
                                     wrq:set_resp_header(
                                       "location",
                                       string:concat("http://localhost:8000/images/",
                                                     filename:basename(StorePath)),
                                       RequestData)),
    {true, NewRequestData, Ctx}.

to_html(RequestData, Ctx) ->
    {"<html><head><title>Webmachine File Upload Example</title></head>"
     "<body><h1>Webmachine File Upload Example</h1>"
     "<form action='/' method='POST' enctype='multipart/form-data'>"
     "Upload File:&nbsp<input type='file' name='filedata'/>"
     "<input type='submit' value='Upload'></form></body></html>", 
     RequestData, Ctx}.

get_streamed_body(done_parts, FileName, Acc) ->
    Bin = iolist_to_binary(lists:reverse(Acc)),
    {FileName, size(Bin)/1024.0, Bin};
get_streamed_body({{"filedata", {Params, _Hdrs}, Content}, Next}, Props, Acc) ->
    FileName = binary_to_list(proplists:get_value(<<"filename">>, Params)),
    get_streamed_body(Next(),[FileName|Props],[Content|Acc]).
