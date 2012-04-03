Confit - A configuration preserver
==================================

Confit allows you to parse and store configuration values for your
applications to use during runtime.

Usage
-----

```erlang
confit:start_link(foo, "foo.config"),
Username = confit:get(foo, database, username)
```

### Parsing other configuration formats

Create a module to parse your configuration format and make sure it exports
a function `parse_file/1` that returns `{ok, Proplist}`. The `confit_parser`
behaviour specifies the interface. See `confit_term_parser.erl`.

For example, to use [Zucchini](https://github.com/devinus/zucchini):

```erlang
confit:start_link(foo, zucchini, "foo.ini"),
Username = confit:get(foo, database, username)
```
