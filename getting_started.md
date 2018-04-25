# Instructions for using the gitbhub repository to manage 2018 GDW material
*Mark Stenglein*
*4.25.2018*

There is now a gdw-workshop github account, and a new repository named 2018_GDW_Workshop where we can deposit workshop content.  We can also take advantage of github’s ability to render markdown format files to make nice looking webpages easily (this page is written in markdown: click Raw above to see the file in the plain text unrendered markdown format).

**Instructions to get started**

- First, you need to create a [github](https://github.com/) account and email me (Mark) your github username.  I will add you as a collaborator to the repository and you will be able to add content to it.  

- These instructions assume you are working on a Mac OS computer with git installed.  If you don’t have git installed, you can get git here: https://git-scm.com/  

- Open the Terminal app in Mac OS

- Use cd to navigate to a folder where you wish to keep a local copy of the repository, which will appear as a directory named 2018_GDW_Workshop.  E.g.:
```
cd ~/teaching
```

- use git to clone the repository (download a local copy):
```
git clone https://github.com/gdw-workshop/2018_GDW_Workshop.git
```

- You should see a new directory called 2018_GDW_Workshop.  It should contain some directories and files.


### To add a file to the repository

Say you want to add a new pdf file (named new.pdf) to the repository. You can do this by moving or copying new.pdf into the 2018_GDW_Workshop directory you created above.  Git will recognize this as a new file not present in the repository.  You can see this by typing:
```
git status
```

You should see something like:
```
On branch master
Your branch is up-to-date with 'origin/master'.
Untracked files:
  (use "git add <file>..." to include in what will be committed)

   new.pdf

nothing added to commit but untracked files present (use "git add" to track)
```

You need to do 3 git operations to get this file up onto the repostory: add it, commit it, and push it:
```
git add new.pdf
git commit -m "added new.pdf to the repo"
git push origin master
```

When you run git push, you are uploading the file and synchronizing this change with the online repository.  You will be prompted for your github username and password.  Note that there is a 50 Mb size limit for individual files. 

If your local copy of the repository is out of date, you will get an error when you try to push and you will have to synchronize your local repository copy before you can push changes.  Do this by running:
```
git pull
```

Make sure you run this from the repository's local directory (cd to that directory before running).  This pull operation should not overwrite any local changes you've made, but you may want to have a backup copy of any changed files just in case.  If there is a conflict between your local repository and the online repository, git will want you to do a [merge](https://help.github.com/articles/resolving-a-merge-conflict-using-the-command-line/) to reconcile the conflict.


### To modify a file in the repository

Say you want to edit a README.md file and push the changes.  Edit the file with your favorite text editor, like textwrangler or something similar.  Then run:

```
git status
```

You should see something like:

```
On branch master
Your branch is up-to-date with 'origin/master'.
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

   modified:   README.md
```

You'll need to do 3 git operations again to sync your changes to the remote repository:
```
git add README.md
git commit -m "updated README with course agenda"
git push origin master
```

This should look like:
```
MDSTENGL-M01:2018_GDW_Workshop _mdstengl$ git add README.md
MDSTENGL-M01:2018_GDW_Workshop _mdstengl$ git commit -m "updated README with course agenda"
[master e3f57e9] updated README with course agenda
 1 file changed, 75 insertions(+), 2 deletions(-)
 rewrite README.md (69%)
MDSTENGL-M01:2018_GDW_Workshop _mdstengl$ git push origin master
Counting objects: 3, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 1.20 KiB | 0 bytes/s, done.
Total 3 (delta 1), reused 0 (delta 0)
remote: Resolving deltas: 100% (1/1), completed with 1 local object.
To https://github.com/gdw-workshop/2018_GDW_Workshop.git
   8bd8d13..e3f57e9  master -> master
```



#### Read more about github and markdown here:
- https://guides.github.com/
- https://github.com/adam-p/markdown-here/wiki/Markdown-Here-Cheatsheet
- https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
- https://guides.github.com/features/mastering-markdown/
