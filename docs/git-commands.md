# To contribute new fetaure

## clone the main repo
git clone git@github.com:datakaveri/iudx-deployment.git && cd iudx-deployment

## Add git remote of your fork 
git remote add my-fork <fork-git-url>

## sync your local git with remote origin(main repo remote) git
git pull origin master

## create a new feature branch from master of remote repo 

git checkout -b <feature-branch-name> 

## Do all ur changes in this branch 

## Stage 
git add <file>

## Commit whatever done in staging and add appropriate message
git commit 

## Push the changes to you fork remote 
git push myy-fork  <feature-branch-name>

## Open a PR from the UI 

