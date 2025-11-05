REPO = https://github.com/math-comp/hierarchy-builder.git
TAG = v1.8.0
WORKDIR = workdir

GIT_FLAGS = -c advice.detachedHead=false --depth=1

.PHONY: all get

all: $(WORKDIR)
	dune build

get: $(WORKDIR)

$(WORKDIR):
	git clone --recursive --depth=1 -b $(TAG) $(REPO) $(WORKDIR)
	( cd $(WORKDIR) && git apply ../patches/paths.patch )
	cp -r dune-files/* $(WORKDIR)/

install:
	dune install coq-hierarchy-builder
