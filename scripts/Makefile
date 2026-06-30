.DEFAULT_GOAL := help

.PHONY: hpl run user add-hostname chrony-head chrony-compute help

hpl:
	ansible-playbook -i inventory.ini setup-hpl.yml --ask-become-pass
run:
	ansible-playbook -i inventory.ini run-hpl.yml --ask-become-pass
user:
	ansible-playbook -i inventory.ini create-user.yml --ask-become-pass
add-hostname:
	ansible-playbook -i inventory.ini add-hostname.yml --ask-become-pass
chrony-head:
	ansible-playbook -i inventory.ini chrony-head.yml --ask-become-pass
chrony-compute:
	ansible-playbook -i inventory.ini chrony-compute.yml --ask-become-pass
	
help:
	@echo "Available commands:"
	@echo "  make hpl              Install HPL"
	@echo "  make run              Run HPL benchmark"
	@echo "  make user             Create a user and group"
	@echo "  make add-hostname     Configure hostname and cluster hosts file"
	@echo "  make chrony-head      Configure head node time sync"
	@echo "  make chrony-compute   Configure compute node time sync"
