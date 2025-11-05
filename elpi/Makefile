REPO = https://github.com/LPCIC/coq-elpi.git
TAG = v2.2.0
COMMIT = fd85ed25c553d0d96ac7078f87bdaada35050e67
WORKDIR = workdir

# Git boilerplate
define GIT_CLONE_COMMIT
mkdir -p $(WORKDIR) && cd $(WORKDIR) && git init && \
git remote add origin $(REPO) && \
git fetch --depth=1 origin $(COMMIT) && git reset --hard FETCH_HEAD
endef

GIT_CLONE = ${if $(COMMIT), $(GIT_CLONE_COMMIT), git clone --recursive --depth=1 -b $(TAG) $(REPO) $(WORKDIR)}

.PHONY: all get prepare

all: $(WORKDIR) prepare
	# must build plugin first
	dune build $(WORKDIR)/src && dune build

prepare: $(WORKDIR)
	@echo '- Installing dependencies -'
	sed -i.bak '/"coq"/d' workdir/coq-elpi.opam  # don't install Coq
	unset DUNE_WORKSPACE && opam install -y --deps-only $(WORKDIR)/
	node adjust_paths.js

get: $(WORKDIR)

$(WORKDIR):
	$(GIT_CLONE)
	( cd $(WORKDIR) && git apply ../patches/test.patch ../patches/dynlink.patch ) # Tests broken with dune
	rm -rf $(WORKDIR)/apps/tc/tests # out of memory with 32bit jscoq
	mkdir $(WORKDIR)/vendor
	cp -r vendor/* $(WORKDIR)/vendor

clean:
	make -C $(WORKDIR) clean
	rm -f $(WORKDIR)/Makefile.coq{,.conf}

install:
	dune install coq-elpi
