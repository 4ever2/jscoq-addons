REPO = https://github.com/Lysxia/coq-simple-io
TAG = 1.11.0
COMMIT = 98d038bba0a481deb1bd03c3e05c5abd5d48be73
WORKDIR = workdir

# Git boilerplate
define GIT_CLONE_COMMIT
mkdir -p $(WORKDIR) && cd $(WORKDIR) && git init && \
git remote add origin $(REPO) && \
git fetch --depth=1 origin $(COMMIT) && git reset --hard FETCH_HEAD
endef
GIT_CLONE = ${if $(COMMIT), $(GIT_CLONE_COMMIT), git clone --recursive --depth=1 -b $(TAG) $(REPO) $(WORKDIR)}

.PHONY: all get

CPPO=${shell cd $(WORKDIR) && find . -name '*.cppo'}

all: $(WORKDIR)
	dune build

get: $(WORKDIR)

$(WORKDIR):
	$(GIT_CLONE)

install:
	dune install coq-simple-io
