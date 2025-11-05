REPO = https://github.com/mattam82/Coq-Equations.git
TAG = v1.3.1-8.20
WORKDIR = workdir

.PHONY: all get

all: $(WORKDIR)
	# not parallel: some Dune dependency mixup with generating META file
	dune build -j1

get: $(WORKDIR)

$(WORKDIR):
	git clone --depth=1 --no-checkout -b $(TAG) $(REPO) $(WORKDIR)
	( cd $(WORKDIR) && git checkout $(TAG) && git apply ../patches/legacy-compat.patch )
	rm $(WORKDIR)/theories/HoTT/dune  # HoTT still not available for 8.14

install:
	dune install coq-equations
