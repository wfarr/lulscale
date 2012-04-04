# Lulscale

A toy Erlang/OTP application for an image upload service.

Built on webmachine and riak.

## Contents

You should find in this directory:

* README : this file
* Makefile : simple make commands
* rebar : the Rebar build tool for Erlang applications
* rebar.config : configuration for Rebar
* start.sh : simple startup script for running lulscale
* /ebin
  * /lulscale.app : the Erlang app specification
* /src
  * /lulscale\_app.erl : base module for the Erlang application
  * /lulscale\_sup.erl : OTP supervisor for the application
  * /lulscale\_resource.erl : a simple example Webmachine resource
* /priv
  * /dispatch.conf : the Webmachine URL-dispatching table
  * /www : a convenient place to put your static web content

## Building the app

    brew install erlang rebar
    make

## Adding New Resources

Create a new resource file:

    src/YOUR_NEW_RESOURCE.erl

And add the resource to:

    priv/dispatch.conf

## Running the Server

    ./start.sh
