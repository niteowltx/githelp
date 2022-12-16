
#==========================================
# Git helper

# Local repo area (edit if necessary)
export GITHELP_LOCAL=~/trunk

# Default remote repo origin (edit if necessary)
export GITHELP_REMOTE=git@github.com:niteowltx

export GITHELP=~/.githelp
export GITHELP_HOME=${GITHELP}/home
export GITHELP_MASTER=${GITHELP}/master

export GITHELP_ID=$$
export GITHELP_HOME_LOC=${GITHELP}/home_${GITHELP_ID}
export GITHELP_ORIGIN_LOC=${GITHELP}/origin_${GITHELP_ID}
export GITHELP_REPO_LOC=${GITHELP}/repo_${GITHELP_ID}
export GITHELP_SANDBOX_LOC=${GITHELP}/sandbox_${GITHELP_ID}
export GITHELP_MASTER_LOC=${GITHELP}/master_${GITHELP_ID}

# make sure the minimums exist
mkdir -p ${GITHELP} >/dev/null 2>&1
touch ${GITHELP_HOME} ${GITHELP_MASTER}

# clear possibly ancient versions
rm -f ${GITHELP_HOME_LOC} ${GITHELP_REPO_LOC} ${GITHELP_SANDBOX_LOC} ${GITHELP_MASTER_LOC} ${GITHELP_ORIGIN_LOC}
touch ${GITHELP_HOME_LOC} ${GITHELP_REPO_LOC} ${GITHELP_SANDBOX_LOC} ${GITHELP_MASTER_LOC}
echo ${GITHELP_REMOTE} >${GITHELP_ORIGIN_LOC}

# Remove config info for processes that no longer exist
cd ${GITHELP}
ls *_*[0-9] 2>/dev/null |sed 's/.*_//' |sort |uniq >.all$$
ps a |grep '[0-9] bash$' | sed 's/^  *//' |sed 's/ .*//'|sort >.active$$
comm -23 .all$$ .active$$ | sed 's/^/rm \*_/' | sh
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
