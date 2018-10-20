cs = require 'coffeescript'
fs = require 'fs'

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
  "build and watch for changes"
  -> loadInstallFileAndDo "watch"
task "clear",
  "remove built files"
  -> loadInstallFileAndDo "clear"
