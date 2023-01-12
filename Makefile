
TARGETS = b ba bd bpush brm bsync fx fxi my_dircmp o r toall
INSTALL_DIR = /usr/local/bin
BASHRC=~/.bashrc

all:

install:	${TARGETS} bashrc
	mkdir -p ${INSTALL_DIR}
	chmod +x ${TARGETS}
	cp -a ${TARGETS} ${INSTALL_DIR}
	-grep -q "export GITHELP" ${BASHRC}; \
		if [ $$? -ne 0 ]; then \
			cat bashrc >> ${BASHRC}; \
		else \
			echo ${BASHRC} appears to already have githelp support; \
		fi

clean:
