#!/bin/sh

if [ $# -ne 1 -a $# -ne 3 -a $# -ne 5 ]; then
    echo "Rationale : Set the author and committer name and email for a number of recent commits."
    echo "Usage     : $(basename $0) <number of commits> [<author name> <author email> [<committer name> <committer email>]]"
    exit 1
fi

if [ $# -eq 1 ]; then
    an="$(git config user.name)"
    ae="$(git config user.email)"
else
    an=$2
    ae=$3
fi

if [ $# -ne 5 ]; then
    cn=$an
    ce=$ae
else
    cn=$4
    ce=$5
fi

if [ $(git rev-list HEAD | wc -l) -eq $1 ]; then
    # We need to rewrite all commits including the root commit.
    range="-- --all"
else
    range="HEAD~$1..HEAD"
fi

git filter-branch -f --env-filter "GIT_AUTHOR_NAME='$an'; GIT_AUTHOR_EMAIL='$ae'; GIT_COMMITTER_NAME='$cn'; GIT_COMMITTER_EMAIL='$ce';" $range
