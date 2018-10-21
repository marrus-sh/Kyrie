#  CONTRIBUTING  #

Kyrie is built by a small team, and we're not really looking for
  outside contributions.
If you have an idea for how we could do things differently—that's
  great!
Kyrie is open-source so that you can implement those ideas on a fork of
  your own.

(It is *not* open-source for the purposes of optimizing labour,
  increasing productivity, building The Best Software Ever, or any
  other reason that places the needs of the product over the needs of
  its developers.)

If you're still reading, that means that either (a) you are a new
  member of the Kyrie team trying to figure out where to get started,
  or (b) you are a third-party trying to understand internally how we
  work, for reasons of your own.
Here's what you need to know:

##  The Files  ##

Kyrie has two components, the KyrieScript parser and the Kyrie engine.
These are located in [`Sources/Parser/`](./Sources/Parser/) and
  [`Sources/Engine/`](./Sources/Engine/), respectively.
There is also a demo in [`Demo/`](./Demo/), and the final built files
  are outputted to [`Build/`](./Build/).

All Kyrie source files are Literate CoffeeScript.
See [`Sources/README.litcoffee`](./Sources/README.litcoffee) for more
  on the formatting and syntax of these files.

Kyrie uses two spaces for indentation and recommends a maximum
  line-length of 71+LF (for a total length of 72 characters).
You should aim for conciceness over clarity in your code, provided you
  have adequately explained what your code is doing in the paragraphs
  immediately preceding or following.
Remember that compiling CoffeeScript to JavaScript is
  [fairly trivial](https://coffeescript.org/#try), so don't be afraid
  to get a little creative if it gets you something you want.

##  Prerequisites  ##

You'll need the Node Package Manager in order to develop for Kyrie.
All other prerequisites are listed in [`package.json`](./package.json)
  and can be installed by running `npm install` (with no arguments).

Kyrie doesn't have any production dependencies and you shouldn't add
  any.
The goal is a single, self-contained, well-documented script.

Kyrie is supposed to be runnable *pretty much everywhere*, and should
  transpile (thanks to Babel) to an ES5.1-compatible script.
Polyfill anything that wouldn't run on Firefox 4.0 / IE 9 / Safari 5.1
  after transpiling.
Kyrie is a simple text-based engine, so this shouldn't be a problem.

##  Contributing Workflow  ##

Every change, regardless of how minor, should be submitted as a PR to
  GitHub.
The final commit in this PR should just be a rebuild of the files in
  [`Build/`](./Build/) (using `npm run prepare`).
Don't bother committing changes to [`Build/`](./Build/) until you are
  ready to merge.
These PRs should then be merged in as a *squash commit*; this ensures
  that the [`Build/`](./Build/) folder always accurately reflects the
  current code at time of commit.

 >  This workflow is a bit cumbersome, but that's intentional.
 >  Taking the time to give your work one last once-over in GitHub
 >    before making the merge helps to catch bugs and keep the software
 >    running as it should.

If changes have been made to the base branch since your fork, you will
  likely need to rebase *before* your final build.
If you forgot to do this, it's easy enough to fix:

```bash
git checkout master
git pull
git checkout my-patch
git reset --hard HEAD^  #  Only do this if you already ran the build
git rebase master
npm run prepare  #  Build
git commit -am "Build for my-patch"
git push origin my-patch
#  [At this point, you should be able to do the squash merge through
#    GitHub]
```

Because of this workflow, PRs should be kept small and only do one or
  two things.
For larger features, it might make sense to merge PRs into a separate
  *feature branch*, which can then be merged into `master` using a
  *merge commit* when complete.
You should run a build as part of the merge (*don't* use the GitHub
  UI):

```bash
git checkout master
git merge --no-ff --no-commit my-feature-branch  #  Begin the merge
#  [Fix any conflicts which aren't in Build/]
npm run prepare  #  Build
git commit -am "Merge my-feature-branch onto master"  #  Finish up
git push origin master
```

As a collaborator, you have the ability to merge PRs yourself, and you
  don't need to wait for prior approval.
However, if the change you're making is a big one, you should probably
  chat about it with others before merging just in case.

##  Licensing and Copyright  ##

If you want credit for your work on Kyrie, be sure to remember to add
  your name to the copyright section at the top of any file which you
  contribute to, and also to the copyright notice in `README.js`, which
  is appended to the beginning of the compiled files.
(Pen names, usernames, and aliases are totally fine.)

By contributing to Kyrie, you agree to license your work under the GNU
  General Public License, Version 3 or any later version, and affirm
  that you have the necessary rights to do so.
