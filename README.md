
	Git Command Line Helper Scripts and Functions

Description

	A set of scripts and bashrc aliases that help in normal
	development workflow when using git (command line).  Short command
	names with almost no options that know how to do the most common
	operations.  Auto-detects 'main' vs. 'master', allows per-repo
	override of this name.	Tries to prevent common mistakes like
	pushing to 'main' or 'master' branches.

Installation

	Edit bashrc GITHELP_LOCAL and/or GITHELP_REMOTE if necessary
	Edit bashrc aliases (maybe you prefer a different 'git diff' style?)
	Edit Makefile to adjust INSTALL_DIR (/usr/local/bin?) if desired
	make install
	exit current shell and start another one to enable .bashrc changes

The Commands

	r		show current repo
	r name		make 'name' your current repo, ask to checkout from github if necessary
	b		show current branch and what other (local) branches are available
	b name		make 'name' the current branch. ask to create if 'name' does not exist
	ba		show all branch names available at the remote origin
	bpush		push all locally commited changes to current branch 
	bd		show repo differences between master and current branch
	brm		remove current branch from local and remote repos, switch to master
	bsync		update current branch from master. Commit any changes to current branch if not master
	s		cd to current repo source directory
	sd		show current (uncommited) differences
	ss		show status of current work area (uncommited/changed/added files)
	sl [files...]	log of current area or specific files
	o		show current remote origin
	o name		set remote origin to 'name'

Normal Workflow

	r somerepo		# select a repo, checkout a copy the first time
	s			# move(cd) to the local copy of the repo
	b mybranch		# a JIRA name, a feature name, or maybe just ${USER}
	while !done
		git add files		# add files to the repo (if needed)
		git rm files		# remove files from the repo (if needed)
		[edit/make/test]	# make changes, build and test the results
		sd			# look at your local diffs
		git commit .		# commit all changes to local repo (most of the time?)
		git commit files...	# commit specific file changes to the local repo (sometimes?)
		b			# verify you are on the branch you think you are
		bpush			# push local changes to your remote branch (do this often...)
		ss			# look for uncommited files, or temp files you can remove
		bsync			# pickup changes from master to your branch
	bd			# see your changes, or use github's web interface
	[on github: create pull request, add reviewers, get approvals]
	[on github: merge your changes to main/master branch, or handoff to SQA/build group and let them do it]
	brm			# when you are completely done with this branch
	cd ${GITHELP_LOCAL}; rm -fr somerepo	# remove repo copy from your system

Abnormal Workflow

	Trying to bsync your branch with the master resulted in merge conflicts.
	Files with conflicts will have lines with <<<<<<<, ======= and >>>>>>> marking the
	areas that are in conflict.  Resolve these manually then:
		git commit -a .
		bpush

	If bsync merge conflicts are too big to fix, abandon the merge and rethink the issue:
		git merge --abort

	You have made changes but not commited them locally (git commit) and do not want any
	of the changes you have made:
		git reset --hard

	You have made changes but not commited them locally (git commit) and are on the wrong
	branch, or want to pull changes from the master to your branch:
		git stash
		b correct-branch	# move to another branch OR
		bsync			# sync with master
		git stash pop

	You need to work with a different remote origin:
		o				# what is your current remote origin
		o git@gitlab.com:repo-name	# switch to a different remote origin

Notes

	All local repos are checked out to sub-directories of ${GITHELP_LOCAL}
	All remote repos are defaulted to a remote origin of ${GITHELP_REMOTE}
	All files for this set of helper scripts are kept in ~/.githelp

	Each shell maintains its own idea of which repo it is working
	on so you can have multiple active repos as long as you use a
	separate shell for each.

	If you have a non-standard repo that does NOT use
	'master' or 'main' as the authoritative named version,
	edit ~/.githelp/master and add a line with 'repo-name official-branch-name'

	If you have a large, complex repo where the default directory you
	want to work in is not the root of the repo, edit ~/.githelp/home
	and add a line with 'repo-name sub-directory', where sub-directory
	is the directory relative to the repo root.  The 's' command
	will then move you to that directory instead of the root.

Suggestions

	git --help -a
	git config --global user.email user.name@user.email
	git config --global user.name "First Last"

	Create an ssh key locally (ssh-keygen) and add it to your github
	account so that it doesn't ask you for verification all the time.
	On github, go to your user preferences, select 'SSH and GPG Keys'
	and add your public key.  If you use multiple systems, consider
	'ssh-copy-id -i' to push the keys to them.  Adjust your git global
	settings on each system you use 'git config'

	Use 'git commit .' and 'bpush' often.  Nothing bad can happen
	to the master repo until you try to merge to master and none of
	these helper tools will allow you to do that.

	Do NOT use .gitignore.	Instead, try to keep the files in your
	directory such that 'make clean' (or equivalent) removes all
	temporary files and leaves the sandbox as if it were just checked
	out.  This can be verified by using the 'ss' command which should
	report no files after a 'clean'.  This can be useful if you forget
	to add a file that is required as it will show up as a ? file.

	If you prefer a GUI, maybe try gitk(free) or gitkraken.com(paid)

	If you think you need to cherry-pick, you're probably wrong.

Non-Git Helper Scripts

	fx pattern	# find . | xargs grep pattern
	fxi pattern	# find . | xargs grep -i pattern
	my_dircmp	# compare 2 directories
	toall		# apply changes to all files (recursively)
