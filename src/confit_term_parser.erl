-module(confit_term_parser).

-behaviour(confit_parser).

-export([parse_file/1]).

parse_file(Filename) ->
    file:consult(Filename).
