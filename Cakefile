cs = require 'coffeescript'
fs = require 'fs'

#  Loads `INSTALL.litcoffee` and `eval`s the compiled file in the
#    context of an empty object.
#  The `INSTALL.litcoffee` will define tasks on `this` which we
#    can then call.
loadInstallFileAndDo = (Task) ->
  fs.readFile "INSTALL.litcoffee", "utf8", (
    (Error, Data) ->
      throw Error if Error
      eval cs.compile Data, literate: yes
      do @[Task]
  ).bind {}

task "build",
  "build Kyrie"
  -> loadInstallFileAndDo "build"
task "watch",
  "build Kyrie and watch for changes"
  -> loadInstallFileAndDo "watch"
task "clear",
  "remove built files"
  -> loadInstallFileAndDo "clear"
