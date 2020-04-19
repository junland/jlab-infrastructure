PWD := $(shell pwd)
GIT_COMMIT:=$(shell git rev-parse --verify HEAD --short=7)
CENGINE := docker
MAKE_RAND := $(shell bash -c 'echo $$RANDOM')

.PHONY: clean
clean:
	rm -rf output/

.PHONY: goaccess
goaccess:
	mkdir -p output/
	$(CENGINE) build -f ./docker/Dockerfile.goaccess-centos -t goaccess-package-$(MAKE_RAND) . && $(CENGINE) create -ti --name goaccess-dummy goaccess-package-$(MAKE_RAND) && $(CENGINE) cp goaccess-dummy:/rpmbuild/RPMS/. output
	$(CENGINE) rm -f goaccess-dummy && $(CENGINE) rmi goaccess-package-$(MAKE_RAND)
	$(CENGINE) build -f ./docker/Dockerfile.goaccess-fedora -t goaccess-package-$(MAKE_RAND) . && $(CENGINE) create -ti --name goaccess-dummy  goaccess-package-$(MAKE_RAND) && $(CENGINE) cp goaccess-dummy:/rpmbuild/RPMS/. output
	$(CENGINE) rm -f goaccess-dummy && $(CENGINE) rmi goaccess-package-$(MAKE_RAND)

.PHONY: znc
znc:
	mkdir -p output/
	$(CENGINE) build -f ./docker/Dockerfile.znc-centos -t znc-package-$(MAKE_RAND) . && $(CENGINE) create -ti --name znc-dummy znc-package-$(MAKE_RAND) && $(CENGINE) cp znc-dummy:/rpmbuild/RPMS/. output
	$(CENGINE) rm -f znc-dummy && $(CENGINE) rmi znc-package-$(MAKE_RAND)
	$(CENGINE) build -f ./docker/Dockerfile.znc-fedora -t znc-package-$(MAKE_RAND) . && $(CENGINE) create -ti --name znc-dummy znc-package-$(MAKE_RAND) && $(CENGINE) cp znc-dummy:/rpmbuild/RPMS/. output
	$(CENGINE) rm -f znc-dummy && $(CENGINE) rmi znc-package-$(MAKE_RAND)