
# report current branch, switch to an existing branch, create a new branch
REPO=`cat ${GITHELP_REPO_LOC}`
SANDBOX=`cat ${GITHELP_SANDBOX_LOC}`
MASTER=`cat ${GITHELP_MASTER_LOC}`
BRANCH=$1

cd ${SANDBOX}

# asking for a list of branches (only local ones?)
if [ "${BRANCH}" == "" ]; then
	git branch --list
	exit 0
fi

# if it exists, just switch to it
git branch -a | sed 's/^..//' | sed 's/^remotes\/origin\///' | grep -q -s -e "^${BRANCH}\$" >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo Switching to existing branch ${BRANCH}
	git checkout ${BRANCH}
	exit 0
fi

if [ "${BRANCH}" == "${MASTER}" -o "${BRANCH}" == "master" -o "${BRANCH}" == "main" ]; then
	echo Creating a branch named ${BRANCH} is probably a bad idea
	exit 1
fi

read -p "Branch ${BRANCH} for repo ${REPO} does not exist.  Create it? [y/N] " yn
if [ "${yn}" != "y" -a "${yn}" != "Y" ]; then
	echo NOT creating branch ${BRANCH}
	exit 1
fi

echo Creating branch ${BRANCH}
git checkout ${MASTER}
git checkout -b ${BRANCH}
bpush
