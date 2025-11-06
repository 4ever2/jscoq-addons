# Inputs to this makefile:
#
# DUNE_WORKSPACE
# CONTEXT
#
# DUNE_WORKSPACE takes priority over CONTEXT

PKGS = coqoban elpi hierarchy-builder mathcomp extlib simpleio \
	   quickchick equations stdpp iris software-foundations

CONTEXT = jscoq+32bit
ifeq ($(DUNE_WORKSPACE:%.64=64), 64)
CONTEXT = jscoq+64bit
endif

# needed when invoking `opam install`
OPAMSWITCH = $(CONTEXT)
export OPAMSWITCH

ifeq ($(DUNE_WORKSPACE),)
ifeq ($(CONTEXT), jscoq+64bit)
DUNE_WORKSPACE = $(PWD)/dune-workspace.64
endif
endif

ifneq ($(DUNE_WORKSPACE),)
export DUNE_WORKSPACE
endif

OPAM_ENV = eval `opam env`

BUILT_PKGS = ${filter $(PKGS), ${notdir ${wildcard _build/$(CONTEXT)/*}}}

_V = ${firstword $(VERSION) $(VER) $(V)}

COMMIT_FLAGS = -a

ifneq ($(_V),)
MSG = [deploy] Prepare for $(_V).
else
_V = ${shell jscoq --version}
MSG = ${error MSG= is mandatory}
endif

.PHONY: world-lite
world-lite:
	cd mathcomp           	&& make && make install    # required by QuickChick

world:
	cd elpi               	&& make && make install    # required by hierarchy-builder
	cd equations          	&& make
	cd extlib             	&& make && make install    # required by SimpleIO
	cd simpleio           	&& make && make install    # required by QuickChick
	cd mathcomp           	&& make && make install    # required by QuickChick
	cd hierarchy-builder  	&& make && make install	   # required by mathcomp
	cd quickchick         	&& make && make install	   # required by software-foundations
	cd coqoban            	&& make
	cd stdpp			  	&& make && make install    # required by iris
	cd iris			  	  	&& make && make install
	cd software-foundations && make

.PHONY: %

env:
	@echo export DUNE_WORKSPACE=$(DUNE_WORKSPACE)

set-ver:
	_scripts/set-ver ${addprefix @,$(CONTEXT)} $(_V)
	if [ -e _build/$(CONTEXT) ] ; then \
	  $(OPAM_ENV) && dune build _build/$(CONTEXT)/*/package.json ; fi  # update build directory as well

pack:
	rm -rf _build/$(CONTEXT)/*.tgz
	_scripts/set-ver ${addprefix @,$(CONTEXT)} $(_V) _build/$(CONTEXT)
	cd _build/$(CONTEXT) && npm pack ${addprefix ./, $(BUILT_PKGS)}

commit-all:
	for d in $(PKGS); do ( cd $$d && git commit $(COMMIT_FLAGS) -m "$(MSG)" ); done
	git commit $(COMMIT_FLAGS) -m "$(MSG)"

push-all:
	for d in $(PKGS); do ( cd $$d && git push $(PUSH_FLAGS) ); done

commit+push-all:
	for d in $(PKGS); do ( cd $$d && \
	   	git commit $(COMMIT_FLAGS) -m "$(MSG)" && \
	    git push $(PUSH_FLAGS) ); done
	git commit $(COMMIT_FLAGS) -m "$(MSG)" && git push $(PUSH_FLAGS)

clean-slate:
	rm -rf */workdir
	rm -rf _build

ci:
	$(MAKE) clean-slate
	$(OPAM_ENV) && $(MAKE)
	$(MAKE) pack

FORCE:

build-%: FORCE
	cd $* && make

install-%: FORCE
	cd $* && make && make install
