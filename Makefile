.PHONY: all clean clean_plt deps compile test doc dialyzer xref ci

EXOMETER_PLT=exometer_core.plt
DIALYZER_OPTS = # -Wunderspecs
DIALYZER_APPS = erts kernel stdlib compiler syntax_tools \
		test_server common_test lager goldrush folsom \
		parse_trans setup

all: compile xref test

ci: compile xref dialyzer test

compile:
	rebar3 compile

clean: clean_plt
	rebar3 clean

test:
	ERL_LIBS=./examples rebar3 ct

xref:
	ERL_LIBS=./deps rebar3 xref

doc:
	rebar3 doc

$(EXOMETER_PLT):
	rebar3 get-deps compile
	ERL_LIBS=deps dialyzer --build_plt --output_plt $(EXOMETER_PLT) \
	--apps $(DIALYZER_APPS)

clean_plt:
	rm -f $(EXOMETER_PLT)

dialyzer: deps compile $(EXOMETER_PLT)
	dialyzer -r ebin --plt $(EXOMETER_PLT) $(DIALYZER_OPTS)
