#!/bin/bash

if git rev-parse > /dev/null 2>&1; then
    branch_name=`git rev-parse --abbrev-ref HEAD`
    commit_id=`git rev-parse HEAD | cut -c 1-10`
    svn_revision=`git log | grep "git-svn-id" | sed 's/^.*@\([0-9]\+\) .*$/\1/' | head -n1`
    echo -n "$branch_name:$commit_id"
    if [ ! -z $svn_revision ]; then
        echo ":r$svn_revision"
    fi
elif svn info > /dev/null 2>&1; then
    svn info | grep Revision | cut -c 11-
else
    echo "???"
fi
