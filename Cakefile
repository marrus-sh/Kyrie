{ build , clear , configure , watch } = require 'Roost'

#  See <https://github.com/marrus-sh/Roost> for the meaning of this
#    configuration.
configure
  destination: "Build/"
  literate: yes
  name: "Kyrie"
  order: [
    "README"
    #  Add common files here
    "Parser/README"
    #  Add additional parser files here
    "Engine/README"
    #  Add additional engine files here
  ]
  preamble: "README.js"
  prefix: "Sources/"
  suffix: ".litcoffee"

task "build", "build Kyrie", build
task "watch", "build Kyrie and watch for changes", watch
task "clear", "remove built files", clear
