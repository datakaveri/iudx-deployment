# Pre-requisite
1.  [install git](https://github.com/git-guides/install-git).
2. Preferably, SSH key based github authentication due to its ease than 
token based over HTTPS url. <br>
  i) [generate ssh key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) <br>
  ii) [add ssh key to github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) <br>
  iii) [test ssh key based github auth](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/testing-your-ssh-connection) 

# To contribute new fetaure
Following is simple step-by-step procedure to contribute to repo through 
git.
1. clone the main repo
```
git clone git@github.com:datakaveri/iudx-deployment.git && cd iudx-deployment
```
2. Fork the git repository from github UI and get the git clone ssh url of the forked repo
ref : https://docs.github.com/en/get-started/quickstart/fork-a-repo

3. Add git remote of your fork,
```
git remote add my-fork <fork-git-clone-url>
```

4. sync your local git with remote origin (i.e. main repository)
```
git pull origin master
```

5. create a new feature branch from master of remote repo 
```
git checkout -b <feature-branch-name> 
```

6.  Do all your file/folder changes in this branch 

7.  Review files and see changes of git tracked files
```
git diff <git-tracked-files>
```
8. Add files to staging
```
git add <file>
```
9. Before commit, review files to be commited (i.e. those in staging)  using ``git status``
10. Commit files (only files in staging will be commited) and add appropriate message in the editor 
```
git commit 
```
The commit message preferrably must contain one line heading covering what commit does.
A detailed explanation (if required) in points as shown below:
```
Adding git docs 

- This is a step by step procedure for git contribution
  to the repo
```

11.  Push the changes to you fork remote 
```
git push my-fork  <feature-branch-name>
```
12.  After pushing the commits, click on the PR url displayed in terminal.
Alternatively, can also create PR from github UI. 
ref: https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork


# Other miscellaneous commands
1. To fetch branch from others fork <br>
1.1  Add the thier fork ``git remote other-fork <fork-git-clone-url>`` <br>
1.2  fetch the branch ``git fetch other-fork <branch-name>`` <br>

