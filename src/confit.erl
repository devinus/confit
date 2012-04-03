-module(confit).
-behaviour(gen_server).

-export([get/1, get/2, get/3, get/4, start_link/2, start_link/3]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
         code_change/3]).

-record(state, {config}).

-spec get(Name :: atom()) -> term().
get(Name) ->
    gen_server:call(Name, get).

-spec get(Name :: atom(), Secton :: term()) -> term().
get(Name, Section) ->
    gen_server:call(Name, {get, Section}).

-spec get(Name :: atom(), Secton :: term(), Key :: term()) -> term().
get(Name, Section, Key) ->
    get(Name, Section, Key, undefined).

-spec get(Name :: atom(), Section :: term(), Key :: term(), Default :: term())
    -> term().
get(Name, Section, Key, Default) ->
    gen_server:call(Name, {get, Section, Key, Default}).

-spec start_link(Name :: atom(), ConfigFile :: string()) -> {ok, pid()}.
start_link(Name, ConfigFile) ->
    start_link(Name, confit_term_parser, ConfigFile).

-spec start_link(Name :: atom(), Parser :: module(), ConfigFile :: string())
    -> {ok, pid()}.
start_link(Name, Parser, ConfigFile) ->
    gen_server:start_link({local, Name}, ?MODULE, [Parser, ConfigFile], []).

init([Parser, ConfigFile]) ->
    {ok, Config} = Parser:parse_file(ConfigFile),
    {ok, #state{config=Config}}.

handle_call(get, _From, #state{config=Config}=State) ->
    {reply, Config, State};
handle_call({get, Section}, _From, #state{config=Config}=State) ->
    Reply = proplists:get_value(Section, Config),
    {reply, Reply, State};
handle_call({get, Section, Key, Default}, _From, #state{config=Config}=State) ->
    SectionConfig = proplists:get_value(Section, Config),
    Reply = proplists:get_value(Key, SectionConfig, Default),
    {reply, Reply, State};
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _Status) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
