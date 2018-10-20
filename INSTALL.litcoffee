<div align="right">
  <b><cite>Kyrie</cite></b><br />
  Source and Documentation<br />
  <code>INSTALL.litcoffee</code>
  <hr />
  <div align="justify">
    Copyright © 2018 Kyebego.
    Released under GNU GPLv3 (or any later version)—for more
      information, see the license notice at the bottom of this
      document.
  </div>
</div>

___

#  INSTALL  #
Building a fresh copy from source

___

##  Description  ##

Kyrie can be easily built using the CoffeeScript build system, Cake.
Just run `cake build` from this directory. You can use `cake clear` to
  delete the built files.

When Cake runs, it loads the [`Cakefile`](./Cakefile), which simply
  loads and runs this file in turn.

___

##  Implementation  ##

###  Prerequisites:

In order to build Kyrie, we'll need access to the filesystem, as well
  as the ability to create child processes.
So we need to require `fs` and `child_process`:

    fs = require 'fs'
    { exec } = require 'child_process'

###  Build order:

Building Kyrie takes place over two steps:

 1. Stitching the source files together, and
 2. Compiling the result

Because variables defined in earlier files will be made available in
  later ones, the ordering of the files is very important.
The following array gives the build order of our source files:

    buildOrder = [
      "README"
      #  Add files which both parser and engine depend upon here.
      "Parser/README"
      #  Add additional parser files here.
      "Engine/README"
      #  Add additional engine files here.
    ]

There is no need to provide the `.litcoffee` extension in our build
  order or the `Sources/` prefix, both of which can be assumed.

###  Loading files:

Our first task will be to load our source files.
The `collect()` function reads our files into an array, which we will
  then pass on to later build steps.

    collect = (sourceFiles) -> (callback) ->
      console.log "Collecting source files…"

We will use the `contents` array to hold the contents of all of our
  source files, in order.
`filesRemaiining` will store the number of files left to process.
We can set both of these at the same time, since the length of the
  contents array will initially equal the number of remaining files.

      contents = new Array filesRemaining = sourceFiles.length

We read each file, in order, and add it to our `contents` array.

      for file, index in sourceFiles
        do (file, index) ->
          fs.readFile "Sources/#{file}.litcoffee", "utf8", (
            error, result
          ) ->
            throw error if error
            contents[index] = result

If we have read all of our available files, we can call our callback
  and move on.

            callback contents if --filesRemaining is 0
      return

###  File stitching:

The `stitch()` function joins an array of files together.
The complicated string of function calls and returns at the beginning
  of `stitch()` is just to make it easier to string together with our
  other functions later on—you'll see this pattern a lot in this file,
  but you needn't pay it much mind.

    stitch = (collector) -> (callback) -> collector (contents) ->
      console.log "Stitching…"

We put a horizontal rule in-between our files to make them easier to
  debug—remember that these are still Literate CoffeeScript at this
  point.

      #  Note that contents should already end in "\n".
      stitchedContents = contents.join "\n#{(Array 72).join "_"}\n\n"

Finally, we write the stitched file to disk, for later compilation.
We have to create the `Build/` folder if it doesn't exist.

      fs.mkdir "Build", (error) ->
        throw error if error and error.code isnt 'EEXIST'
        fs.writeFile "Build/Kyrie.litcoffee",
          stitchedContents, "utf-8", (error) ->
            throw error if error
            callback "Build/Kyrie.litcoffee"
      return

##  Compiling  ##

The `compile()` function compiles our stitched Literate CoffeeScript
  file.
It's pretty simple—it just executes `coffee`, adding a license and
  usage notice to the beginning of the file with `cat`.
Note the `-t` flag; we will use Babel for transpiling into an
  ECMAScript 5.1–compatible form.

    compile = (stitcher) -> (callback) -> stitcher (stitched) ->
      console.log "Compiling…"
      compiled = stitched.replace /\.litcoffee$/i, ".js"
      exec "
        coffee -cpt #{stitched} | cat README.js - > #{compiled}
      ", (error, stdout, stderr) ->
        throw error if error
        console.log (stdout or "") + (stderr or "") if stdout or stderr
        callback compiled
      return

##  Minifying  ##

Finally, we use UglifyJS 3 to minify our final output.
We again add a license/usage notice to the beginning of the file.
The `minify()` function accomplishes this:

    minify = (compiler) -> compiler (compiled) ->
      console.log "Minifying…"
      minified = compiled.replace /\.js$/, ".min.js"
      exec "
        uglifyjs #{compiled} -c | cat README.js - > #{minified}
      ", (error, stdout, stderr) ->
        throw error if error
        if stdout or stderr
          console.log (stdout or "") + (stderr or "")
        console.log "…Done."
      return

##  Building  ##

The `build()` function just links all of the above functions together:

    @build = build = -> minify compile stitch collect buildOrder

##  Watching  ##

The `watch()` function builds, then watches for changes and
  automatically rebuilds.

    @watch = watch = ->
      do build
      for file in buildOrder
        do (file) ->
          fs.watch "Sources/#{file}.litcoffee", "utf8", (type) ->
            return unless type is "change"
            console.log "File `#{file}` changed, rebuilding..."
            do build

##  Clearing  ##

The `clear()` function clears out the files that we created above:

    @clear = clear = ->
      fs.unlink "Build/Jelli.litcoffee", ->  #  Ignore errors
      fs.unlink "Build/Jelli.js"       , ->  #  Ignore errors
      fs.unlink "Build/Jelli.min.js"   , ->  #  Ignore errors

___

<details>
  <summary>License notice</summary>
  <p>This file is a part of Kyrie.</p>
  <p>Kyrie is free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.</p>
  <p>Kyrie is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
    General Public License for more details.</p>
  <p>You should have received a copy of the GNU General Public License
    along with this source. If not, see
    https://www.gnu.org/licenses/.</p>
</details>
