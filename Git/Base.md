# Git Lab Contents
This lab purpose is to install and use Git to become familiar with this distributed configuration management system and handle some of the common use cases around it.

## Lab Writers and Trainers
- Bruno.Cornec@hpe.com
- Clement.Poulain@hpe.com

<!--- [comment]: # Table of Content to be added --->

## Objectives of the Git Lab
At the end of the Lab students should be able to install git, use the CLI to clone a new repository, make modifications to projects, providing updates in the project, manages branches, conflicts, multi developers aspects, and have some best practices references. They should also become more familiar with the Web based interface provided by GitLab and the Pull Requests, issue tracking aspects it provides in addition.

This Lab is intended to be trial and error so that during the session students should understand really what is behind the tool, instead of blindly following instructions, which never teach people anything IMHO. You've been warned ;-)

Expected duration : 120 minutes

## Reference documents
When dealing with the installation and configuration of Git, the first approach is to look at the reference Web site https://git-scm.com/docs. Students could also download the Cheat Sheet at https://training.github.com/kit/downloads/github-git-cheat-sheet.pdf.
For details on additional web based interface tools, you may want to look at https://training.github.com/kit/courses/github-for-developers.html and https://www.digitalocean.com/community/tutorials/how-to-use-the-gitlab-user-interface-to-manage-projects.

This lab would not have been possible without work done by people at Atlassian at https://www.atlassian.com/git/
<!--- and http://gitref.org/ --->

Estimated time for the lab is placed in front of each part.

# Environment setup

Estimated time: 10 minutes (including remote access to the platform described elsewhere)

## Git installation
Git is available externaly from https://git-scm.com/downloads or using your distribution packages.
Version 2.7.3 is the current stable release. The version used in this Lab will be the default version of Ubuntu LTS 14.04 1.9.1.

As we'll work on an Ubuntu environment for the Lab, you may want to use apt to do the installation of Git with all its dependencies. 

`#` **`apt-get update`**

`#` **`apt-get install -y git`**
```none
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following extra packages will be installed:
  git-man liberror-perl
Suggested packages:
  git-daemon-run git-daemon-sysvinit git-doc git-el git-email git-gui gitk
  gitweb git-arch git-bzr git-cvs git-mediawiki git-svn
Recommended packages:
  patch
The following NEW packages will be installed:
  git git-man liberror-perl
0 upgraded, 3 newly installed, 0 to remove and 0 not upgraded.
Need to get 3,421 kB of archives.
After this operation, 21.9 MB of additional disk space will be used.
Get:1 http://ftp.free.fr/mirrors/ftp.ubuntu.com/ubuntu/ trusty/main liberror-perl all 0.17-1.1 [21.1 kB]
[...]
Fetched 3,421 kB in 0s (4,643 kB/s)
Selecting previously unselected package liberror-perl.
(Reading database ... 52804 files and directories currently installed.)
Preparing to unpack .../liberror-perl_0.17-1.1_all.deb ...
[...]
Setting up git (1:1.9.1-1ubuntu0.2) ...
[...]
```
Other distributions should be as easy to deal with by providing the same packages out of the box (Case of most non-commercial distributions such as Debian, Fedora, Mageia, OpenSuSE, …)
Check that the correct version is installed and operational:

`#` **`git --version`**
```
git version 1.9.1
```
`#` **`git`**

[Display online help]

Now that the software has been installed, we'll use it to create and manage software repositories. For that, we'll connect now a simple user, as we don't need any priviledge anymore. Your user is group**X** and password ilovegit**X** where **X** has to be replaced by the group number given by your instructor. Please substitute **X** later in this document by your group number.

# Using Git locally

Estimated time: 25 minutes.

## Git setup

`userX:~$` **`git config --global user.name groupX`**

`userX:~$` **`git config --global user.email gitlab_groupX@hpe.com`**
 
`userX:~$` **`git config --global core.editor vim`**

This will allow us to get correct information in the log and be able to track who does what, especially when reviewing history and also when using GitLab later. For edition uses either vim if your comfortable with vi type of editors or emacs, or do not use it to use a basic beginners friendly one. Check with:

`userX:~$` **`git config -l`**
```
user.name=groupX
user.email=gitlab_groupX@hpe.com
[...]
core.editor=vim
```

This is stored in your `~/.gitconfig` file.

## The first local repository
In order to be able to manage a first repository, the easiest approach is to create a local one. For that issue:

`userX:~$` **`git init localrepo`**
```
Initialized empty Git repository in /home/groupX/localrepo/.git/
```
`userX:~$` **`ls -al localrepo`**
```
total 12
drwxrwxr-x 3 group3 group3 4096 Mar 11 19:07 .
drwxr-xr-x 4 group3 group3 4096 Mar 11 19:13 ..
drwxrwxr-x 7 group3 group3 4096 Mar 11 19:07 .git
```

So now we've created a git repository. It doesn't hold much yet, because you haven't created or changed any files.
We can now start using it to manage some content. But before that, we want to configure our Git setup a little.

## Managing content in your local repository

### Populating the repository

We will add some content in our local directory, start making modifications, see how Git reacts, then try to check those changes in.

`userX:~$` **`cp -a /etc/ssh localrepo/`**

`userX:~$` **`cd localrepo/`**

`userX:~/localrepo$` **`cd localrepo/`**

`userX:~/localrepo$` **`ls ssh`**
```
moduli  ssh_config  sshd_config  ssh_host_dsa_key.pub  ssh_host_ecdsa_key.pub  ssh_host_ed25519_key.pub  ssh_host_rsa_key.pub
```
`userX:~/localrepo$` **`git status`**
```
On branch master

Initial commit

Untracked files:
  (use "git add <file>..." to include in what will be committed)

        ssh/

nothing added to commit but untracked files present (use "git add" to track)
```

Here Git suggests that we add the newly created directory to track it and its content in the future, so we can manage its history as modifications are made to it. Let's do that.

`userX:~/localrepo$` **`git add ssh`**

`userX:~/localrepo$` **`git status`**
```
On branch master

Initial commit

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

        new file:   ssh/moduli
        new file:   ssh/ssh_config
        new file:   ssh/ssh_host_dsa_key.pub
        new file:   ssh/ssh_host_ecdsa_key.pub
        new file:   ssh/ssh_host_ed25519_key.pub
        new file:   ssh/ssh_host_rsa_key.pub
        new file:   ssh/sshd_config

```
So Git is now aware that we want to keep track of all these files. We will now initialize our repository with this new content, use the editor to give the reasons we've made a change and validate this.

`userX:~/localrepo$` **`git commit`**

**`Import of content into the repository`**

**`- Adds ssh conf files`**
```
# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
# On branch master
#
# Initial commit
#
# Changes to be committed:
#       new file:   ssh/moduli
#       new file:   ssh/ssh_config
#       new file:   ssh/ssh_host_dsa_key.pub
#       new file:   ssh/ssh_host_ecdsa_key.pub
#       new file:   ssh/ssh_host_ed25519_key.pub
#       new file:   ssh/ssh_host_rsa_key.pub
#       new file:   ssh/sshd_config
#
```
```
[master (root-commit) da8a15f] Import of content into the repository
 7 files changed, 407 insertions(+)
 create mode 100644 ssh/moduli
 create mode 100644 ssh/ssh_config
 create mode 100644 ssh/ssh_host_dsa_key.pub
 create mode 100644 ssh/ssh_host_ecdsa_key.pub
 create mode 100644 ssh/ssh_host_ed25519_key.pub
 create mode 100644 ssh/ssh_host_rsa_key.pub
 create mode 100644 ssh/sshd_config
```
`userX:~/localrepo$` **`git log`**
```
commit da8a15fdd80aa40c97b4501d1a342eba052639fd
Author: groupX <gitlab_groupX@gmail.com>
Date:   Fri Mar 11 19:33:54 2016 +0100

    Import of content into the repository
    
    - Adds ssh conf files
```

As you can see, Git identifies our import by a unique commit ID, which will remain valid during the whole life of the project.

### Modifying content

Now that we have some content, let's start making modifications and see how Git deals with them ! Edit 2 files in the `ssh` directory, modify some content in it (we do not care about correctness at this point) and validate these 2 sets of modifications. Review your modification (expressed as a patch format - lines starting with a '+' will be added and those starting with a '-' will be removed):

`userX:~/localrepo$` **`git status`**
```
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   ssh/ssh_config
        modified:   ssh/sshd_config

no changes added to commit (use "git add" and/or "git commit -a")
```
`userX:~/localrepo$` **`git diff`**
```
diff --git a/ssh/ssh_config b/ssh/ssh_config
index 3810e13..4bdd247 100644
--- a/ssh/ssh_config
+++ b/ssh/ssh_config
@@ -1,3 +1,6 @@
+#   RhostsRSAAuthentication no
+#   RSAAuthentication yes
+#   PasswordAuthentication yes
 
 # This is the ssh client system-wide configuration file.  See
 # ssh_config(5) for more information.  This file provides defaults for
@@ -20,9 +23,6 @@ Host *
 #   ForwardAgent no
 #   ForwardX11 no
 #   ForwardX11Trusted yes
-#   RhostsRSAAuthentication no
-#   RSAAuthentication yes
-#   PasswordAuthentication yes
 #   HostbasedAuthentication no
 #   GSSAPIAuthentication no
 #   GSSAPIDelegateCredentials no
diff --git a/ssh/sshd_config b/ssh/sshd_config
index fa6377d..38ef297 100644
--- a/ssh/sshd_config
+++ b/ssh/sshd_config
@@ -22,6 +22,7 @@ ServerKeyBits 1024
 # Logging
 SyslogFacility AUTH
 LogLevel INFO
+#AuthorizedKeysFile    %h/.ssh/authorized_keys
 
 # Authentication:
 LoginGraceTime 120
@@ -30,7 +31,6 @@ StrictModes yes
 
 RSAAuthentication yes
 PubkeyAuthentication yes
-#AuthorizedKeysFile    %h/.ssh/authorized_keys
 
 # Don't read the user's ~/.rhosts and ~/.shosts files
 IgnoreRhosts yes
@@ -61,12 +61,12 @@ ChallengeResponseAuthentication no
 #GSSAPIAuthentication no
 #GSSAPICleanupCredentials yes
 
+#UseLogin no
 X11Forwarding yes
 X11DisplayOffset 10
 PrintMotd no
 PrintLastLog yes
 TCPKeepAlive yes
-#UseLogin no
 
 #MaxStartups 10:30:60
 #Banner /etc/issue.net
```
These modifications are for now in your working directory, but nothing happened to your repository. You can easily cancel all these modifications if you want (Hint use `git reset`). Now, we can add these changes to git's staging area, and from the staging area commit those changes to the repository. You should only commit related changes in a single commit (e.g. commit either a bugfix or a new feature, not both) to make it easy to see which changes are connected later. As an example (do not select all changes):

`userX:~/localrepo$` **`git add -p`**
```
diff --git a/ssh/ssh_config b/ssh/ssh_config
index 3810e13..4bdd247 100644
--- a/ssh/ssh_config
+++ b/ssh/ssh_config
@@ -1,3 +1,6 @@
+#   RhostsRSAAuthentication no
+#   RSAAuthentication yes
+#   PasswordAuthentication yes
 
 # This is the ssh client system-wide configuration file.  See
 # ssh_config(5) for more information.  This file provides defaults for
Stage this hunk [y,n,q,a,d,/,j,J,g,e,?]? y
@@ -20,9 +23,6 @@ Host *
 #   ForwardAgent no
 #   ForwardX11 no
 #   ForwardX11Trusted yes
-#   RhostsRSAAuthentication no
-#   RSAAuthentication yes
-#   PasswordAuthentication yes
 #   HostbasedAuthentication no
 #   GSSAPIAuthentication no
 #   GSSAPIDelegateCredentials no
Stage this hunk [y,n,q,a,d,/,K,g,e,?]? y
diff --git a/ssh/sshd_config b/ssh/sshd_config
index fa6377d..38ef297 100644
--- a/ssh/sshd_config
+++ b/ssh/sshd_config
@@ -22,6 +22,7 @@ ServerKeyBits 1024
 # Logging
 SyslogFacility AUTH
 LogLevel INFO
+#AuthorizedKeysFile    %h/.ssh/authorized_keys
 
 # Authentication:
 LoginGraceTime 120
Stage this hunk [y,n,q,a,d,/,j,J,g,e,?]? n
@@ -30,7 +31,6 @@ StrictModes yes
 
 RSAAuthentication yes
 PubkeyAuthentication yes
-#AuthorizedKeysFile    %h/.ssh/authorized_keys
 
 # Don't read the user's ~/.rhosts and ~/.shosts files
 IgnoreRhosts yes
Stage this hunk [y,n,q,a,d,/,K,j,J,g,e,?]? n
@@ -61,12 +61,12 @@ ChallengeResponseAuthentication no
 #GSSAPIAuthentication no
 #GSSAPICleanupCredentials yes
 
+#UseLogin no
 X11Forwarding yes
 X11DisplayOffset 10
 PrintMotd no
 PrintLastLog yes
 TCPKeepAlive yes
-#UseLogin no
 
 #MaxStartups 10:30:60
 #Banner /etc/issue.net
Stage this hunk [y,n,q,a,d,/,K,g,s,e,?]? y
```

In fact, as a best practice, you should systematically use that `-p` option in order to select precisely the modifications which are part of a commit you want to create that will be documented using the editor during the commit. Especially, contrary to what git says, avoid using `git commit -a` especially blindly when you have not touched your repository in the last 10 days e.g.

`userX:~/localrepo$` **`git status`**
```
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        modified:   ssh/ssh_config
        modified:   ssh/sshd_config

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   ssh/sshd_config
```

`userX:~/localrepo$` **`git diff`**
```
diff --git a/ssh/sshd_config b/ssh/sshd_config
index 4c294c6..38ef297 100644
--- a/ssh/sshd_config
+++ b/ssh/sshd_config
@@ -22,6 +22,7 @@ ServerKeyBits 1024
 # Logging
 SyslogFacility AUTH
 LogLevel INFO
+#AuthorizedKeysFile    %h/.ssh/authorized_keys
 
 # Authentication:
 LoginGraceTime 120
@@ -30,7 +31,6 @@ StrictModes yes
 
 RSAAuthentication yes
 PubkeyAuthentication yes
-#AuthorizedKeysFile    %h/.ssh/authorized_keys
 
 # Don't read the user's ~/.rhosts and ~/.shosts files
 IgnoreRhosts yes
```
So one modification wasn't accepted and is shown with the diff command. The other modifications are now in the staging area, ready to be committed. However, as indicated by Git, you can still revert these modification, if you realize they were incorrect. But how can you review them before committing to be sure ?

`userX:~/localrepo$` **`git diff --cached`**
```
diff --git a/ssh/ssh_config b/ssh/ssh_config
index 3810e13..4bdd247 100644
--- a/ssh/ssh_config
+++ b/ssh/ssh_config
@@ -1,3 +1,6 @@
+#   RhostsRSAAuthentication no
+#   RSAAuthentication yes
+#   PasswordAuthentication yes
 
 # This is the ssh client system-wide configuration file.  See
 # ssh_config(5) for more information.  This file provides defaults for
@@ -20,9 +23,6 @@ Host *
 #   ForwardAgent no
 #   ForwardX11 no
 #   ForwardX11Trusted yes
-#   RhostsRSAAuthentication no
-#   RSAAuthentication yes
-#   PasswordAuthentication yes
 #   HostbasedAuthentication no
 #   GSSAPIAuthentication no
 #   GSSAPIDelegateCredentials no
diff --git a/ssh/sshd_config b/ssh/sshd_config
index fa6377d..38ef297 100644
--- a/ssh/sshd_config
+++ b/ssh/sshd_config
@@ -61,12 +61,12 @@ ChallengeResponseAuthentication no
 #GSSAPIAuthentication no
 #GSSAPICleanupCredentials yes
 
+#UseLogin no
 X11Forwarding yes
 X11DisplayOffset 10
 PrintMotd no
 PrintLastLog yes
 TCPKeepAlive yes
-#UseLogin no
 
 #MaxStartups 10:30:60
 #Banner /etc/issue.net
```

`userX:~/localrepo$` **`git commit`**

**`Moves comments around`**

**`- Improve comments for ssh configuration`**

**`- another modification for sshd config`**

```
# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
# On branch master
# Changes to be committed:
#       modified:   ssh/ssh_config
#       modified:   ssh/sshd_config
#
# Changes not staged for commit:
#       modified:   ssh/sshd_config
#
[master d63d43d] Moves comments around
 2 files changed, 4 insertions(+), 4 deletions(-)
```
`userX:~/localrepo$` **`git log`**
```
commit d63d43d38e6cce80e8ad4240ecb03f033a84dbf7
Author: group3 <gitlab_group3@gmail.com>
Date:   Fri Mar 11 20:30:54 2016 +0100

    Moves comments around
    
    - Improve comments for ssh configuration
    - another modification for sshd config

commit da8a15fdd80aa40c97b4501d1a342eba052639fd
Author: group3 <gitlab_group3@gmail.com>
Date:   Fri Mar 11 19:33:54 2016 +0100

    Import of content into the repository
    
    - Adds ssh conf files
```
`userX:~/localrepo$` **`git status`**
```
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   ssh/sshd_config

no changes added to commit (use "git add" and/or "git commit -a")
```

If you used -a then git would have also included your last modification which wasn't staged. This is not what we want, so just use `git commit`. Our last modification is still in our working directory waiting to be finalyzed and committed.

You may want to have a look at https://www.atlassian.com/git/tutorials/saving-changes for more discussions around these aspects.

As you can start to see, there is *always* a way to solve an issue with Git. But if you now look at the man pages of say the `git log`, you will see how rich each subcommand is, so very powerful, but also sometimes confusing, espeically for newcomers with regards to finding the right option to perform the action you look at.

`userX:~/localrepo$` **`man git-log | wc -l`**
```
1449
```
`userX:~/localrepo$` **`man git-log | grep -E '^\s*-' | wc -l`**
```
167
```
Yes, 167 options to the single `git log` command. Suffice to say that lab will just cover the surface of Git, as we're all still learning (Linus excepted ;-) But let's explore some useful among them.

`userX:~/localrepo$` **`git log --oneline`**
```
d63d43d Moves comments around
da8a15f Import of content into the repository
```
`userX:~/localrepo$` **`git log --oneline --stat`**
```
d63d43d Moves comments around
 ssh/ssh_config  | 6 +++---
 ssh/sshd_config | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)
da8a15f Import of content into the repository
 ssh/moduli                   | 261 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ssh/ssh_config               |  54 ++++++++++++++++++++++
 ssh/ssh_host_dsa_key.pub     |   1 +
 ssh/ssh_host_ecdsa_key.pub   |   1 +
 ssh/ssh_host_ed25519_key.pub |   1 +
 ssh/ssh_host_rsa_key.pub     |   1 +
 ssh/sshd_config              |  88 +++++++++++++++++++++++++++++++++++
 7 files changed, 407 insertions(+)
```
`userX:~/localrepo$` **`git log --graph --decorate --oneline`**
```
* d63d43d (HEAD, master) Moves comments around
* da8a15f Import of content into the repository
```

That last one will become more useful later one, once we have more content in our history. But these commands may also help us reverting changes. You may again want to look at this page https://www.atlassian.com/git/tutorials/inspecting-a-repository for more insights

### Reverting modifications

Of course, you may make mistakes and revert your modifications sometimes. For example, you currently have a unvalidated modification in your working directory. Revert it with `git checkout`

`userX:~/localrepo$` **`git status`**
```
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        modified:   ssh/sshd_config

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   ssh/sshd_config
```
`userX:~/localrepo$` **`git checkout -- ssh/sshd_config`**

`userX:~/localrepo$` **`git status`**
```
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        modified:   ssh/sshd_config

```
So you lost the local modifications made which were not added yet. Now what about the one committed if you also don't want it either ?

`userX:~/localrepo$` **`git reset HEAD ssh/sshd_config`**
```
Unstaged changes after reset:
M       ssh/sshd_config
```
`userX:~/localrepo$` **`git status`**
```
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   ssh/sshd_config

no changes added to commit (use "git add" and/or "git commit -a")
```
`userX:~/localrepo$` **`git diff`**
```
diff --git a/ssh/sshd_config b/ssh/sshd_config
index 4c294c6..7449d4d 100644
--- a/ssh/sshd_config
+++ b/ssh/sshd_config
@@ -4,8 +4,8 @@
 # What ports, IPs and protocols we listen for
 Port 22
 # Use these options to restrict which interfaces/protocols sshd will bind to
-#ListenAddress ::
 #ListenAddress 0.0.0.0
+#ListenAddress ::
 Protocol 2
 # HostKeys for protocol version 2
 HostKey /etc/ssh/ssh_host_rsa_key
```
`userX:~/localrepo$` **`git checkout -- ssh/sshd_config`**

`userX:~/localrepo$` **`git status`**
```
On branch master
nothing to commit, working directory clean
```

Finally you may want to revert a modification already pushed to your repository. The best practice with this is to create a new commit that will revert the action of the old one instead of going back to history to avoid messing it up and those who may depend on it.

`userX:~/localrepo$` **`git log --oneline`**
```
d63d43d Moves comments around
da8a15f Import of content into the repository
```
Let's imagine we want to come back to our initial state on our repository (commit da8a15f) and revert the modification made in commit d63d43d.
`userX:~/localrepo$` **`git revert d63d43d`**
```
Revert "Moves comments around"

This reverts commit d63d43d38e6cce80e8ad4240ecb03f033a84dbf7.

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
# On branch master
# Changes to be committed:
#       modified:   ssh/ssh_config
#       modified:   ssh/sshd_config
#
[master 42b2008] Revert "Moves comments around"
 2 files changed, 4 insertions(+), 4 deletions(-)
```
`userX:~/localrepo$` **`git log --oneline`**
```
42b2008 Revert "Moves comments around"
d63d43d Moves comments around
da8a15f Import of content into the repository
```

For a more detailed explanation on this topic, and looking at more options to manage going back and forth in your history you may refer to https://www.atlassian.com/git/tutorials/viewing-old-commits and https://www.atlassian.com/git/tutorials/undoing-changes

It's now time to organize a bit better our development approach.

### Managing branches

Branches are at the heart of the development method with Git. Each time you want to make modifciations to an existing code base, it is advised to create a branch to develop that feature. It will ease greatly management of features integration, errors, share with upstream, ... Also look at https://www.atlassian.com/git/tutorials/using-branches/git-branch.

`userX:~/localrepo$` **`git branch`**
```
* master
```
`userX:~/localrepo$` **`git branch comment`**

`userX:~/localrepo$` **`git branch`**
```
  comment
* master
```
`userX:~/localrepo$` **`git checkout comment`**
```
Switched to branch 'comment'
```

So you've now created the `comment` branch and have moved to it. All what you do from now on will be on this branch which originates from `master`.

`userX:~/localrepo$` **`git log --oneline`**
```
42b2008 Revert "Moves comments around"
d63d43d Moves comments around
da8a15f Import of content into the repository
```

Redo multiple local modifications as earlier and commit them into your banch (use `git add -p` and `git commit` each time). Your history should then look like this in that branch, but doesn't affect `master`:

`userX:~/localrepo$` **`git log --oneline`**
```
695521e Activate banner + comments moved again
4ad763e Change comments
42b2008 Revert "Moves comments around"
d63d43d Moves comments around
da8a15f Import of content into the repository
```
`userX:~/localrepo$` **`git checkout master`**
```
Switched to branch 'master'
```
`userX:~/localrepo$` **`git log --oneline`**
```
42b2008 Revert "Moves comments around"
d63d43d Moves comments around
da8a15f Import of content into the repository
```
If you are in a multi-user environment, working with a remote repository, that branch may even have progressed during the time you developed you feature in your `comment` branch. Commit a change in your `master` branch to simulate this in a separate file from the one you touched during your feature addition.

`userX:~/localrepo$` **`git log --oneline`**
```
d5a50f4 Modify a key
42b2008 Revert "Moves comments around"
d63d43d Moves comments around
da8a15f Import of content into the repository
```

Now what happens when you go bak into your feature branch ? Let's test !

`userX:~/localrepo$` **`git checkout comment`**
```
Switched to branch 'comment'
```
`userX:~/localrepo$` **`git log --oneline`**
```
695521e Activate banner + comments moved again
4ad763e Change comments
42b2008 Revert "Moves comments around"
d63d43d Moves comments around
da8a15f Import of content into the repository
```

So we just see the modifications done in that branch, not the one done in `master`. But we would like to get that modification made in `master` so we can propose our feature to `master` later on, including it instead of creating a conflict. So it's time to rebase !

`userX:~/localrepo$` **`git rebase master`**
```
First, rewinding head to replay your work on top of it...
Applying: Change comments
Applying: Activate banner + comments moved again
```
`userX:~/localrepo$` **`git log --oneline`**
```
df3e445 Activate banner + comments moved again
82f564d Change comments
d5a50f4 Modify a key
42b2008 Revert "Moves comments around"
d63d43d Moves comments around
da8a15f Import of content into the repository
```

So the magic happened ! Git took the `master` branch and re-applied our 2 patches on top of that tree so our `comment` branch is now uptodate. Do you have the same commit IDs as before after the end of the rebase operation ? Why ? Now Add a final modification, commit it and it's now time to declare our feature complete and ready for integration into master.

`userX:~/localrepo$` **`git log --oneline`**
```
7965bf5 Adds limits
df3e445 Activate banner + comments moved again
82f564d Change comments
d5a50f4 Modify a key
42b2008 Revert "Moves comments around"
d63d43d Moves comments around
da8a15f Import of content into the repository
```
`userX:~/localrepo$` **`git checkout master`**
```
Switched to branch 'master'
```
`userX:~/localrepo$` **`git log --oneline`**
```
d5a50f4 Modify a key
42b2008 Revert "Moves comments around"
d63d43d Moves comments around
da8a15f Import of content into the repository
```

So `master` has no knowledge of the feature branch, let's merge it into this branch.

`userX:~/localrepo$` **`git merge --no-ff comment`**
```
Merge branch 'comment'

- Adds more comments and activatr some features
# Please enter a commit message to explain why this merge is necessary,
# especially if it merges an updated upstream into a topic branch.
#
# Lines starting with '#' will be ignored, and an empty message aborts
# the commit.
Merge made by the 'recursive' strategy.
 ssh/ssh_config  | 4 ++--
 ssh/sshd_config | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)
```
`userX:~/localrepo$` **`git log --graph --decorate --oneline`**
```
*   a18fdd3 (HEAD, master) Merge branch 'comment'
|\  
| * 7965bf5 (comment) Adds limits
| * df3e445 Activate banner + comments moved again
| * 82f564d Change comments
|/  
* d5a50f4 Modify a key
* 42b2008 Revert "Moves comments around"
* d63d43d Moves comments around
* da8a15f Import of content into the repository
```
`userX:~/localrepo$` **`git branch -d comment`**
```
Deleted branch comment (was 7965bf5).
```

Using the `--no-ff` option has allowed us to keep track of the origin of the path set (a feature branch) and integrate all the changes into our `master` branch which now contains everything we want. Of course, sometimes rebasing or merging doesn't succeed and you have to deal with merge conflicts, solving them, before being able to continue. Git guides you throughout the process so you can fix your conflicts. Depending on time you may want to experiment with a conflicting change to familiarize yourself with this situation.However, you should now have an understanding of all the basics to manipulate content with Git. It's then time to collaborate with others.

# Using Git collaboratively

Estimated time: 15 minutes.

In order to have a more interesting environment, we'll now look to work with another group, so each of you can deal with a remote repository. If you're even group number (2p) deal with the previous odd one (2p-1), and if you're an odd group number (2p-1) deal the for even after you (2p). You're now a single team working on the same project, using the repository of the odd group as the reference one.

`userX:~/localrepo$` **`git remote add origin ssh://groupX@10.3.222.22/home/groupX/localrepo`**

`userX:~/localrepo$` **`git remote update`**
```
Fetching origin
The authenticity of host '10.3.222.22 (10.3.222.22)' can't be established.
RSA key fingerprint is 49:46:58:dc:ac:cd:d2:07:7d:d7:14:45:b9:18:1a:2c.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '10.3.222.22' (RSA) to the list of known hosts.
group3@10.3.222.22's password:
```
`userX:~/localrepo$` **`git remote -v`**
```
origin  ssh://group3@10.3.222.22/home/group3/localrepo (fetch)
origin  ssh://group3@10.3.222.22/home/group3/localrepo (push)
```

Now that you're referencing your upstream repository, push your modifications into it.

`userX:~/localrepo$` **`git config --global push.default matching`**

`userX:~/localrepo$` **`git push origin master`**
```
group3@10.3.222.22's password: 
Counting objects: 61, done.
Delta compression using up to 6 threads.
Compressing objects: 100% (48/48), done.
Writing objects: 100% (61/61), 16.32 KiB | 0 bytes/s, done.
Total 61 (delta 23), reused 0 (delta 0)
To ssh://group3@10.3.222.22/home/group3/localrepo
 * [new branch]      master -> master
```

Once each group has been able to push its changes into its own remote repository, it's time to exchange ! The goal will be to take their modifications of a new feature as the current status of the development and push that to your upstram repository, assuming you're in charge of the integration work. The other group is called Y after.

`userX:~/localrepo$` **`git remote add partner ssh://groupY@10.3.222.22/home/groupY/localrepo`**

`userX:~/localrepo$` **`git remote update`**
```
Fetching origin
group3@10.3.222.22's password: 
Fetching partner
group4@10.3.222.22's password: 
warning: no common commits
remote: Counting objects: 10, done.
remote: Compressing objects: 100% (9/9), done.
remote: Total 10 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (10/10), done.
From ssh://10.3.222.22/home/group4/localrepo
 * [new branch]      master     -> partner/master
```
`userX:~/localrepo$` **`git remote -v`**
```
origin  ssh://group3@10.3.222.22/home/group3/localrepo (fetch)
origin  ssh://group3@10.3.222.22/home/group3/localrepo (push)
partner ssh://group4@10.3.222.22/home/group4/localrepo (fetch)
partner ssh://group4@10.3.222.22/home/group4/localrepo (push)
```

Now that you're referencing the other group's repository, merge their modifications into your `master` branch and push the modifications upstream.

`userX:~/localrepo$` **`git merge partner/master`**
```
Auto-merging ssh/sshd_config
CONFLICT (add/add): Merge conflict in ssh/sshd_config
Auto-merging ssh/ssh_host_dsa_key.pub
CONFLICT (add/add): Merge conflict in ssh/ssh_host_dsa_key.pub
Auto-merging ssh/ssh_config
CONFLICT (add/add): Merge conflict in ssh/ssh_config
Automatic merge failed; fix conflicts and then commit the result.
```

Well, of course that doesn't work as you did changes at same places without coordination, so the merge can not be done automatically. You'll have to fix it manually. Make your mind with regards to which one are the right one.

`userX:~/localrepo$` **`git diff`**
```
diff --cc ssh/ssh_config
index bc10a1e,3810e13..0000000
--- a/ssh/ssh_config
+++ b/ssh/ssh_config
@@@ -17,11 -17,11 +17,19 @@@
  # ssh_config(5) man page.
  
  Host *
++<<<<<<< HEAD
 +#   RhostsRSAAuthentication no
 +#   RSAAuthentication yes
 +#   ForwardAgent no
 +#   ForwardX11 no
 +#   ForwardX11Trusted yes
++=======
+ #   ForwardAgent no
+ #   ForwardX11 no
+ #   ForwardX11Trusted yes
+ #   RhostsRSAAuthentication no
+ #   RSAAuthentication yes
++>>>>>>> Initialize content
  #   PasswordAuthentication yes
  #   HostbasedAuthentication no
  #   GSSAPIAuthentication no
[...]
```
`userX:~/localrepo$` **`vi ssh/ssh_config ssh/sshd_config [...]`**
```
[Solve conflicts]
```
`userX:~/localrepo$` **`git add ssh/ssh_config ssh/sshd_config [...]`**

`userX:~/localrepo$` **`git status`**
```
On branch test
All conflicts fixed but you are still merging.
  (use "git commit" to conclude merge)

Changes to be committed:

        modified:   ssh/ssh_config
        modified:   ssh/ssh_host_dsa_key.pub
        modified:   ssh/sshd_config

```
`userX:~/localrepo$` **`git commit`**
```
Merge remote-tracking branch 'partner/master' into HEAD

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
# On branch test
# All conflicts fixed but you are still merging.
#
# Changes to be committed:
#       modified:   ssh/ssh_config
#       modified:   ssh/ssh_host_dsa_key.pub
#       modified:   ssh/sshd_config
#

[test ebb1e45] Merge remote-tracking branch 'partner/master' into HEAD
```
`userX:~/localrepo$` **`git log --graph --oneline --decorate`**
```
*   97c375f (HEAD) Merge remote-tracking branch 'partner/master' into HEAD
|\  
| * 0516e10 (partner/master) Initial commit
*   e8a5727 (origin/master) Merge branch 'test'
|\  
| *   a18fdd3 Merge branch 'comment'
| |\  
| | * 7965bf5 Adds limits
| | * df3e445 Activate banner + comments moved again
| | * 82f564d Change comments
| |/  
| * d5a50f4 Modify a key
| * 42b2008 Revert "Moves comments around"
| * d63d43d Moves comments around
| * da8a15f Import of content into the repository
* 7fa61ab Adds limits
* eb09283 Activate banner + comments moved again
* e83a2f0 Change comments
* 571e395 Revert "Moves comments around"
* 70484ae Moves comments around
* 66d9ede Import of content into the repository
* e662067 Initialize content
```

You're now ready to update the upstream repository with your updated content.

`userX:~/localrepo$` **`git branch --set-upstream-to=origin/master master`**
```
Branch master set up to track remote branch master from origin.
```
`userX:~/localrepo$` **`git push`**
```
group3@10.3.222.22's password: 
Counting objects: 57, done.
Delta compression using up to 6 threads.
Compressing objects: 100% (37/37), done.
Writing objects: 100% (47/47), 4.30 KiB | 0 bytes/s, done.
Total 47 (delta 23), reused 0 (delta 0)
To ssh://group3@10.3.222.22/home/group3/localrepo
   e8a5727..2693204  master -> master
```

# Best practices and collaborative development with Git

Estimated time: 10 minutes.

You should read the blog article from Vincent Driessen available at http://nvie.com/posts/a-successful-git-branching-model/ to familiarize yourself with some best practices around collaborative development. Also read as well https://www.atlassian.com/git/tutorials/comparing-workflows.

# Code and project management with Git using GitLab

Estimated time: 45 minutes.

GitLab is a software and a company.
GitLab, the software, is a web-based Git repository manager with code reviews, issue tracking, continuous integration, and wikis features.
It can be compared to Github, with one major difference: it is an open-source project, that you can run on your own infrastructure.
GitLab is very active, and released on a monthly basis.

GitLab, the company, has 37 salaried employees and more than 700 open source contributors.

## Access GitLab

For this lab, we have installed a GitLab instance, accessible at *http://10.3.222.22:5454*. (Check that Javascript is enbaled as GitLab used it)

With your favorite browser, access this address, and you will land on the homepage of our GitLab instance. 

An account has already been created for you. The username is **groupX**, and the password is **ilovegitX**, where **X** is your group number.
Enter them into the *Sign In* dialog, and you should enter the wonderful world of GitLab!

## Discover GitLab with our Awesome Project

The GitLab instance has been populated with a small project, that we will use to discover GitLab. 
The **Awesome Project** (yes, this is the name of our project) is a revolutionary project that deals with fruits, vegetables, numbers, colors and other things.

Take some time to discover the different panels of GitLab:

- The **Dashboard** centralizes the information *you* need for your work:
  - **Projects** you have access to
  - **Todos** are similar to notifications, listing what is new and what you need to pay attention to
  - **Activity** lists all actions taken by everybody working on same projects than you
  - **Groups** you are part of
  - **Milestones** of any project you work on
  - **Issues** currently assigned to you, from any project
  - **Merge Request**\* currently assigned to you, from any project
  - **Snippets** are the digital equivalent of post-it notes

\* a *Merge Request* is a proposition of code to be reviewed. It is used to start a discussion prior to get the code accepted and merged (or reworked if needed!). We will see that in details shortly.

When you select a **project**, you will find some information about the *git project* itself, like the number of commits, or the size of the repository. Under those numbers, you will find a description of the project; we will see later how to edit this description.

The left-hand side menu now displays project-related entries. Take some time to discover all of them, and navigate in the project. In particular, but not exclusively, give a look to the **Files** of the project, the **Commits** list (from there, don't miss the **Network** graph!), and then **Issues** and **Merge Requests**.

## Locally clone Awesome Project

In order to get access to git repositories managed by GitLab, you need to configure an SSH key in your account. On your system, issue first:

`userX:~/localrepo$` **`ssh-keygen < /dev/null`**

`userX:~/localrepo$` **`cat .ssh/id_rsa.pub`**

To achieve that, access your Profile configuration page. From the **Dashboard**, you have a direct access to your **Profile settings** on the left-hand side menu. Once you are there, you will find an entry called **SSH Keys** menu. Click there, and copy the content of the public key previously displayed.

During git operations, GitLab identifies the user based on the email address configured in git. Knowing that, it is very important that your user name and email address are correctly configured. You can verify that by running:

```
git config --global user.name
git config --global user.email
```

Your user name should be **Group X** and your email address **gitlab_groupX@hpe.com**, where **X** is your group number. If not, you can fix it by running:

```
git config --global user.name "Group X"
git config --global user.email "gitlab_groupX@hpe.com"
```

On the **awesome-project** homepage, you will find the URL to be used to clone the project. Clone the project on your machine, as you have learned previously. Congratulation, you are ready to go!
Hint:

`userX:~/localrepo$` **`git clone http://10.3.222.22:5454/tes_lab/awesome-project`**



## Edit your first file from GitLab

As you will become an active contributor of the **Awesome Project**, your first task will be to add your names to the contributors list.

You have seen this list in the description of the project. This description is actually stored into a file that is part of the project, like any other one. From the **Files** panel you will find it at the root of the project, name **README.md**. Navigate to it, and click the **edit** button.
Within this editor, edit the line corresponding to your group number and write your names. You can review your changes with the **Preview changes** button. 
**Markdown** is used everywhere across GitLab, in order to format any text, like issue descriptions or wiki pages. Please take some time to discover the [GitLab Markdown guide](http://10.3.222.22:5454/help/markdown/markdown.md).

Now it gets interesting. As your are **developer** of the project, not **master** or **owner**, you don't have write permission to the `master` branch. In order to have your contribution included into the `master` branch, you have to create and submit a **merge request**. 

Verify that **Start a new merge request with these changes** is checked. Enter a concise description of the change your are proposing in **Commit message**, and choose a relevant branch name. Upon submission, a commit will be created on this new branch, and the **Merge Request** dialog will open.
Fill the required fields (description, milestone, label(s)), and **assign** the merge request to one of the project maintainers. The commits inclued in this merge request are listed under the form. You have one last opportunity to review them before submitting the merge request.
You branch will be automatically merged into `master` when the assignee will accept your merge request, making your changes available for everybody.

Once your merge request is accepted, you can check your are now listed as contributors in the project description.

## Enter your first issue

*In this section, less details are given. This is done on purpose, so you can try by your own to find the best solution to achieve given tasks.*

Our project is not perfect; it is containing some bugs. Each group will have to discover one bug, and follow it up until it gets fixed.

Here are bugs that lovely users reported to us; each of them is assigned to a group:

1. Group 1: something is wrong with the **vegetables list**
2. Group 2: the **ascending numbers feature** looks to be broken
3. Group 3: the **black and white** feature behaves strangely
4. Group 4: **odd numbers** are sometimes not really odd numbers
5. Group 5: **France flag colors** are blue, white and red, nothing more
6. Group 6: the **descending numbers feature** looks to be broken
7. Group 7: something is wrong with the **fruits list**
8. Group 8: **even numbers** are sometimes not really even numbers
9. Group 9: the **colors** feature behaves strangely
10. Group 10: something is wrong with the **drinks list**

Now you have to gather additional information in order to open an issue containing as much details as possible.
Follow this typical workflow in order to report an issue:

- investigate the bug assigned to your group
  - find the **file** containing the bug (each of those simple bugs are contained into a single file)
  - in that file, find the guilty **line**
  - using GitLab features, discover the **commit** that introduced this line, and its **author**
- report the issue
  - write a precise **description** of the problem, containing all information you gathered (file, line, commit, author...) \*
  - fill additional fields like **tag** and **milestone**
  - assign it to the **next group**. (Group1 assigns to Group2, Group2 to Group3 ... Group10 to Group1)

\* [Special GitLab references](http://10.3.222.22:5454/help/markdown/markdown.md#special-gitlab-references) are **very** useful to report an issue.

## Fix your first issue with your first merge request

An issue is now assigned to you. It contains all information you need to start working on it and fix this nasty bug.

Editing files from GitLab interface is useful for small changeset, but it is not as usable as a real text editor.

Within your local repository you have cloned at the beginning of this section, edit the relevant file to fix the bug.
Don't be afraid, it should be as easy as modifying or removing a single line!

Once you are happy with your modification, create a **new branch**, and **commit** your change. Then **push** it to the remote repository.
Back to GitLab dashboard, GitLab will tell you that you have pushed a new branch; it will propose you to create a **merge request** based on this branch. 
Add any relevant information to your **merge request**. In particular, make sure the description contains **Fixes #xxx** where "xxx" is the issue number you were assigned. By doing this, you will allow GitLab to **automatically close** this issue once your merge request is accepted.

Assign it to the **previous group** (Group1 assigns to Group10, Group2 to Group1 ...)

## Accept your first merge request

A merge request is now assigned to you. Take some time to read it, understand what issue it addresses and how it resolves it.

Now you have two choices:
- if you are satisfied with the merge request, write a little comment saying so, and accept the merge request.
- if you are **not** satisfied, add a comment explaining why. The assignee will be notified, and can argue or commit more things to improve the merge request.

As a reviewer, the responsibility of this code is now shared between you and the author. This is a very important step in a collaborating workflow.

## Conclusion

In this section, all the participants of this lab have worked together on the **awesome-project**, using GitLab as a project management tool.

To conclude this lab, please look again at the **network graph** to see all the branches that we created converging into master.
You can also look at the **activity** page, and the **issue**, **merge request** and **milestone** lists, to review what has been done and what is still to be done.

When all issues assigned to a milestone are closed, it is time to release our product, and start working on the next milestone!

## Thanks!

