LF_URL = https://softwarefoundations.cis.upenn.edu/lf-current/lf.tgz
PLF_URL = https://softwarefoundations.cis.upenn.edu/plf-current/plf.tgz
VFA_URL = https://softwarefoundations.cis.upenn.edu/vfa-current/vfa.tgz
QC_URL = https://softwarefoundations.cis.upenn.edu/qc-current/qc.tgz
SLF_URL = https://softwarefoundations.cis.upenn.edu/slf-current/slf.tgz
WORKDIR = workdir
SUBDIRS = common lf plf vfa slf

.PHONY: all get clean

all: $(WORKDIR)
	dune build

get: $(WORKDIR)

$(WORKDIR):
	mkdir workdir
	(cd $(WORKDIR) && \
	curl -L $(LF_URL) | tar zx && \
	curl -L $(PLF_URL) | tar zx && \
	curl -L $(VFA_URL) | tar zx && \
	curl -L $(QC_URL) | tar zx && \
	curl -L $(SLF_URL) | tar zx)
	cp -r dune-files/* $(WORKDIR)/
	find $(WORKDIR)/ -name "*.html" -type f -delete
	find $(WORKDIR)/ -name "*Test.v" -type f -delete
	rm -r $(WORKDIR)/lf/.devcontainer/ $(WORKDIR)/lf/common/ \
		  $(WORKDIR)/plf/.devcontainer/ $(WORKDIR)/plf/common/ \
		  $(WORKDIR)/vfa/.devcontainer/ $(WORKDIR)/vfa/common/ \
		  $(WORKDIR)/qc/.devcontainer/ $(WORKDIR)/qc/common/ \
		  $(WORKDIR)/slf/.devcontainer/ $(WORKDIR)/slf/common/
	find $(WORKDIR)/ -name "*.v" -type f -print0 | xargs -0 sed -i 's/Stdlib/Coq/g'

clean:
	rn -r $(WORKDIR)
