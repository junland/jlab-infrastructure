PACKER_BIN := packer

all: centos8-base centos8-faas centos8-gitlab

centos8-base:
  $(PACKER_BIN) build centos8-base.json
  
centos8-faas:
  $(PACKER_BIN) build centos8-faas.json
  
centos8-gitlab:
  $(PACKER_BIN) build centos8-gitlab.json
