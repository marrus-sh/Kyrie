<div align="right">
  <b><cite>Kyrie</cite></b><br />
  Source and Documentation<br />
  <code>Sources/README.litcoffee</code>
  <hr />
  <div align="justify">
    Copyright © 2018 Kyebego.
    Released under GNU GPLv3 (or any later version)—for more
      information, see the license notice at the bottom of this
      document.
  </div>
</div>

#  KYRIE  #
🌄🎼 A scripting engine for dialogue and text

___

##  Description  ##

This folder contains all of the source code for Kyrie.
Kyrie is written in Literate CoffeeScript, which means that each source
  file can be read as Markdown, and serves as its own documentation.
The code blocks (indented with four spaces) in each file are the
  CoffeeScript code.
This file is the [`README`](README.litcoffee), and is, in fact, a file
  in the engine's source.

####  Browser compatibility

The anticipated (ie, untested) browser compatibility for Kyrie is as
  follows:

| Chrome | Firefox | Internet Explorer | Opera | Safari |
| :----: | :-----: | :---------------: | :---: | :----: |
|    7   |   4.0   |         9         |   12  |   5.1  |

###  Components:

###  How to read this source:

Kyrie is broken into two components: the <dfn>parser</dfn>, which
  reads a KyrieScript file and outputs a data structure that the
  engine can understand, and the <dfn>engine</dfn>, which provides
  the public API for interacting with scripts.
The sources for these components can be found in
  [`Parser/`](./Parser/) and [`Engine/`](./Engine/), respectively.
You should read the former if you are looking to write KyrieScript
  files, and the latter if you are looking to build a technology
  which interacts with them.

It is not necessary to understand all of the code behind Kyrie in order
  to put it into use.
In fact, the extensive documentation provided exists precisely to make
  it accessible without forcing users to dig through code.
When browsing the source, each block of code is usually explained in
  the paragraphs immediately preceding or following it, so feel free to
  skim over code blocks when you have a decent idea of what is going
  on.

Kyrie is still under active development, and errors in the code are
  likely present.
Issues may be submitted through
  [GitHub](https://github.com/marrus-sh/Kyrie/issues) should any bugs
  be discovered.

###  Document structure:

Each source file is split into two main parts.
The first, titled "Description", outlines and documents the features
  defined in the file and how to use them.
The second, titled "Implementation", provides and explains the source
  code.
Readers looking to use Kyrie need largely only concern themselves with
  the first section, but readers aiming for a deeper understanding of
  how Kyrie operates under the hood should read both.

###  Formatting conventions:

Source files are written in GitHub-Flavored Markdown (GFM), utilizing
  fenced code-blocks for non-compiled source.

This is a paragraph.
It is in a section titled “Formatting conventions”.
`This` is a code excerpt, this is *emphasis*, and this is
  **important**.
Here is a [link](http://example.com/).

+   This is a short unordered list
+   In the source, there is minimal padding between and around lines

>   **Note :**
>   This is a note.

1.  This is a short ordered list
2.  Here is item #2
3.  Short list items like these don't end in periods

>   **[Issue ##](https://github.com/marrus-sh/jelli/issues) :**
>   This is a note regarding a known issue.

+   This is a list with paragraph content.
    For these kinds of lists, there is more padding in the source and
      each sentence ends with a period.

+   Note that each list item may contain at most one paragraph, because
      the CoffeeScript compiler will otherwise try to interpret the
      second as code.

+   Although this is an unordered list, an ordered list with paragraph
      content would be formatted in much the same way.

>   ```coffeescript
>   ###
>   This is a sample block of CoffeeScript code.
>   It will not appear in the compiled source.
>   ###
>   ```

>   ```javascript
>   /*
>   Usually, though, documentation examples are written in plain
>   JavaScript.
>   */
>   ```

>   ```text
>   %(
>   This is a plain-text code block, used (for example) to present
>   KyrieScript code.
>   )%
>   ```

>   ```html
>   <!DOCTYPE html>
>   <title>Sample html</title>
>   <p> And here is a block of HTML.
>   ```

The following is a line break:

___

The following is a subsection titled “Case conventions and variable names”.

####  Case conventions and variable names

Kyrie uses camelCase for all variables, and for functions which are not
  intended to be used as a constructor.
PascalCase is used for functions which *are* intended as constructors.
In the source, parentheses should *never* be used to provide arguments
  for functions; for example:

>   ```coffeescript
>   do myFunction                                #  No arguments
>   new myConstructor                            #  No arguments
>   myFunction (1 + 2), "three"                  #  Two arguments
>   new myConstructor (callback) -> do callback  #  One argument
>   ```

####  Don't be confused!

This source uses Unicode characters in some variable names.

The letter `U+01C3 ǃ LATIN LETTER RETROFLEX CLICK` is used in function
  names to denote a function that either throws an error or returns
  `undefined`.
This is _not_ the same character as `U+0021 ! EXCLAMATION MARK`, which
  will never appear in this source directly following a variable name.

___

##  Implementation  ##

This is the first file in the Kyrie source.
(For the complete source order, see the
  [`INSTALL`](../INSTALL.litcoffee) file.)
We start things off by entering into strict mode.

    "use strict"

###  Getting the global object:

Kyrie is designed to be useäble in (virtually) any browser without any
  fancy compilation or features—just include `/Build/Kyrie.min.js`, and
  the various objects are made available to you on the `window` object.
However, it also supports CommonJS `exports`, and will attempt to set
  its properties there if `self` and `window` are not defined.
The `global` variable stores this object for convenience.

    global = self ? (window ? (exports ? null))
    unless global?
      throw new ReferenceError "Unable to find global object."

###  Special constructors:

Kyrie makes use of two special kinds of constructor functions:
  functions which *must* be called as constructors, and constructor
  functions which *cannot* be called.

####  Functions which must be called as constructors

Many Kyrie functions can only be called as constructors.
We define the `constructǃ` function locally to make checking for
  this easy.
For a function `MyConstructor` which must be called as a constructor,
  `constructǃ @, MyConstructor, "MyConstructor"` should be the
  first line in its source.

    constructǃ = (theThis, constructor, type) ->
      throw new TypeError "#{type} must be called as a
        constructor." unless theThis?
      throw new TypeError "This is not a
        #{type}." unless theThis instanceof constructor

Kyrie's definition of a "constructor" does *not* require the use of
  `new`.
For example, `MyConstructor.call Object.create MyConstructor::` counts
  as a constructor call, because the `this` value passed to the
  constructor implements the correct `prototype`.
This enables constructor subclassing without depending on ES2015
  features like `class` and `super`.

####  Constructor functions which cannot be called

The generator function `Ø` generates uncallable constructors.
This is used when publicly exposing the prototype of objects which
  should not be constructable by external scripts.
`Ø` takes as its arguments an `identifier`, which will be inferred as
  the function name (not actually in ES 5.1, but potentially in later
  versions), and a `prototype`, which is the (real) prototype for the
  (fake) constructor.

    Ø = (identifier = "anonymous", prototype = Object::) ->
      obj = [identifier]: -> throw new TypeError "Illegal constructor."
      Object.defineProperty obj[identifier], "prototype",
        configurable: no
        value: prototype
        writable: no

###  The `kyrie` object:

All Kyrie constants, objects, and constructors are made available
  through the `kyrie` global object.
The `kyrie` object is technically an instance of `Kyrie`—but this
  constructor doesn't do anything and can't actually be called.

    Object.defineProperty (Kyrie = ->)::, "constructor",
      configurable: no
      value: Ø "Kyrie", Kyrie::
      writable: no
    kyrie = new Kyrie

Kyrie targets vanilla ES 5.1, so it doesn't use modules or similar.
It simply attaches itself to the global object at `"kyrie"`.
For the adventurous, you can also access the `kyrie` object from
  the emoji sequence `"🌄🎼"`.

    Object.defineProperties global,
      kyrie:
        configurable: yes
        value: kyrie
      "🌄🎼":
        configurable: yes
        value: kyrie

###  Identity Information:

The global `kyrie` object identifies itself using a number of
  properties, so that one can easily tell which version they are using
  (and build tools which support multiple versions!)

    Object.defineProperties kyrie,

The `ℹ` property provides an identifying URI for the API author of this
  version of Kyrie.
If you fork Kyrie and change its API, you should also change this
  value.

      ℹ: value: "https://go.KIBI.family/Kyrie/"

The `Nº` property provides the version number of this version of Kyrie
  as an object with three parts: `major`, `minor`, and `patch`.
It is up to the API author (identified above) to determine how these
  parts should be interpreted.
It is recommended that the `toString()` and `valueOf()` methods be
  implemented as well.

      Nº: value: Object.freeze
        major: 0
        minor: 0
        patch: 0
        toString: -> "#{@major}.#{@minor}.#{@patch}"
        valueOf: -> @major * 100 + @minor + @patch / 100

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

_______________________________________________________________________

<div align="right">
  <b><cite>Kyrie</cite></b><br />
  Source and Documentation<br />
  <code>Sources/Parser/README.litcoffee</code>
  <hr />
  <div align="justify">
    Copyright © 2018 Kyebego.
    Released under GNU GPLv3 (or any later version)—for more
      information, see the license notice at the bottom of this
      document.
  </div>
</div>

#  KYRIE:PARSER  #
KyrieScript syntax and parsing

___

##  Description  ##

_To come._

___

##  Implementation  ##

    #  [TK]  #

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

_______________________________________________________________________

<div align="right">
  <b><cite>Kyrie</cite></b><br />
  Source and Documentation<br />
  <code>Sources/Engine/README.litcoffee</code>
  <hr />
  <div align="justify">
    Copyright © 2018 Kyebego.
    Released under GNU GPLv3 (or any later version)—for more
      information, see the license notice at the bottom of this
      document.
  </div>
</div>

#  KYRIE:ENGINE  #
Kyrie Behaviours and API

___

##  Description  ##

_To come._

___

##  Implementation  ##

    #  [TK]  #

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
