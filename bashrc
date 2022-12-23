
#==========================================
# Git helper

# Local repo area (edit if necessary)
export GITHELP_LOCAL=~/trunk

# Default remote repo origin (edit if necessary)
export GITHELP_REMOTE=git@github.com:niteowltx

export GITHELP=~/.cache/githelp
export GITHELP_HOME=${GITHELP}/home
export GITHELP_MASTER=${GITHELP}/master

export GITHELP_ID=${GITHELP}/$$
export GITHELP_HOME_LOC=${GITHELP_ID}/home
export GITHELP_ORIGIN_LOC=${GITHELP_ID}/origin
export GITHELP_REPO_LOC=${GITHELP_ID}/repo
export GITHELP_SANDBOX_LOC=${GITHELP_ID}/sandbox
export GITHELP_MASTER_LOC=${GITHELP_ID}/master

# make sure the minimums exist
mkdir -p ${GITHELP_ID}
touch ${GITHELP_HOME} ${GITHELP_MASTER}

# clear possibly ancient versions
rm -f ${GITHELP_HOME_LOC} ${GITHELP_REPO_LOC} ${GITHELP_SANDBOX_LOC} ${GITHELP_MASTER_LOC} ${GITHELP_ORIGIN_LOC}
touch ${GITHELP_HOME_LOC} ${GITHELP_REPO_LOC} ${GITHELP_SANDBOX_LOC} ${GITHELP_MASTER_LOC}
echo ${GITHELP_REMOTE} >${GITHELP_ORIGIN_LOC}

# Remove config info for processes that no longer exist
cd ${GITHELP}
ls -d [0-9]* 2>/dev/null | tr ' ' '\012' | sort |uniq >.all$$
pidof bash sh | tr ' ' '\012' |sort >.active$$
comm -23 .all$$ .active$$ | sed 's/^/rm -fr /' | sh
rm -f .all$$ .active$$
cd - >/dev/null 2>&1

# s = cd to current project's source directory
alias s='cd `cat ${GITHELP_HOME_LOC}`'
# sd = source diff
alias sd="git diff -w ."
# ss = source status
alias ss="git status -s ."
# sl = source log
alias sl="git log --stat -p"
#alias sl="git log --oneline --graph --decorate"
