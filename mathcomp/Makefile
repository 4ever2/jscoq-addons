REPO = https://github.com/math-comp/math-comp.git
TAG = mathcomp-2.2.0
WORKDIR = workdir

# Regular package set
SUBPKGS = ssreflect fingroup algebra field solvable character
COQSUBPKGS = coq-mathcomp-ssreflect coq-mathcomp-fingroup coq-mathcomp-algebra coq-mathcomp-field coq-mathcomp-solvable coq-mathcomp-character

# Git boilerplate
define GIT_CLONE_COMMIT
mkdir -p $(WORKDIR) && cd $(WORKDIR) && git init && \
git remote add origin $(REPO) && \
git fetch --depth=1 origin $(COMMIT) && git reset --hard FETCH_HEAD
endef
GIT_CLONE = ${if $(COMMIT), $(GIT_CLONE_COMMIT), git clone --recursive --depth=1 -c advice.detachedHead=false -b $(TAG) $(REPO) $(WORKDIR)}

.PHONY: all get

all: $(WORKDIR)
	cp -r dune-files/* $(WORKDIR)/
	dune build

get: $(WORKDIR)

$(WORKDIR):
	$(GIT_CLONE)

install:
	dune install $(COQSUBPKGS)
