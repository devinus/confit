-module(confit_parser).

-callback parse_file(Filename :: string())
    -> {ok, [{term(), term()}, ...]}.
