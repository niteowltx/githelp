#!/bin/bash

ORIGIN=`cat ${GITHELP_ORIGIN_LOC}`

# report current repo, or switch to new repo

if [ "${GITHELP_LOCAL}" == "" ]; then
	echo "No GITHELP_LOCAL?"
	exit 1
fi
mkdir -p ${GITHELP_LOCAL} >/dev/null 2>&1

REPO=$1
SANDBOX=${GITHELP_LOCAL}/${REPO}

# just asking for current repo
if [ "${REPO}" == "" ]; then
	if [ -e ${GITHELP_REPO_LOC} ]; then
		cat ${GITHELP_REPO_LOC}
	fi
	exit 0
fi

# create if it does not exist
if [ ! -d ${SANDBOX} ]; then
	git ls-remote ${ORIGIN}/${REPO} >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo "Remote Repository ${ORIGIN}/${REPO} not found"
		exit 1
	fi

	read -p "Local Repository ${REPO} does not exist.  Create local clone of it? [y/N] " yn
	if [ "${yn}" != "y" -a "${yn}" != "Y" ]; then
		echo NOT creating ${REPO}
		exit 1
	fi

	cd ${GITHELP_LOCAL}
	git clone --recursive ${ORIGIN}/${REPO} ${REPO}
fi

echo ${REPO}    > ${GITHELP_REPO_LOC}
echo ${SANDBOX} > ${GITHELP_SANDBOX_LOC}

# set starting directory from preference file, default is ${SANDBOX}
HOMEDIR=`grep ${REPO} ${GITHELP_HOME} | sed 's/.*\s//'`
echo ${SANDBOX}/${HOMEDIR}  > ${GITHELP_HOME_LOC}

# set master/main from preference file, or determine it automatically
MASTER=`grep ${REPO} ${GITHELP_MASTER} | sed 's/.*\s//'`
if [ "${MASTER}" == "" ]; then
	cd ${SANDBOX}
	MASTER=`git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'`
fi
echo ${MASTER}  > ${GITHELP_MASTER_LOC}
