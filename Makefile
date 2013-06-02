
all:
	make core

core: get-deps
	@./rebar skip_deps=true compile

deps: get-deps
	@./rebar compile

get-deps:
	@./rebar get-deps

nodeps:
	@./rebar compile

update-deps:
	@./rebar update-deps


clean:
	@./rebar clean
	rm -f erl_crash.dump

dist-clean: clean


edoc:
	# ./rebar doc skip_deps=true
	erl -noshell -eval 'edoc:application(ocean, ".", []), init:stop().'
	(cd mod && make edoc)

edoc-clean:
	rm -rf doc/*.html

