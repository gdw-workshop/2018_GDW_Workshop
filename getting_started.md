# Instructions for using the gitbhub repository to manage 2018 GDW material
**Mark Stenglein**
**4.25.2018**

There is now a gdw-workshop github account, and a new repository named 2018_GDW_Workshop where we can deposit workshop content.  We can also take advantage of github’s ability to render markdown format files to make nice looking webpages easily (this page is written in markdown)..  

**Instructions to get started**

- These instructions assume you are working on a Mac OS computer with git installed.  If you don’t have git installed, you can get it here: https://git-scm.com/  

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


**To add a file to the directory**

Say you want to add a new pdf file (named new.pdf) to the repository. You can do this by copying new.pdf into the 2018_GDW_Workshop directory you created above.  Git will recognize this as a new file not present in the repository.  You can see this by typing:
```
git status
```

You should see your new.pdf file 




Note that there is a 50 Mb size limit for individual files. 



Read more about github and markdown here:
- https://guides.github.com/
- https://github.com/adam-p/markdown-here/wiki/Markdown-Here-Cheatsheet
- https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
- https://guides.github.com/features/mastering-markdown/
