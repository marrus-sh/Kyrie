/*
#  KYRIE  #
🌄🎼 A scripting engine for dialogue and text

___

Implemented through several modules in Literate CoffeeScript.
Source code and resources are available at
  <https://github.com/marrus-sh/Kyrie/>.

___

##  License  ##

Copyright © 2018 Kyebego.

This program is free software: you can redistribute it and/or modify it
  under the terms of the GNU General Public License as published by the
  Free Software Foundation, either version 3 of the License, or (at
  your option) any later version.

This program is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

If you downloaded this file as part of a larger repository, you should
  have received a copy of the GNU General Public License along with
  this program.
Otherwise, see <https://www.gnu.org/licenses/>.

___

##  How To Use  ##

To come.

*/
"use strict";

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

(function () {
  "use strict";

  var Kyrie, constructǃ, global, kyrie, Ø;
  global = typeof self !== "undefined" && self !== null ? self : typeof window !== "undefined" && window !== null ? window : typeof exports !== "undefined" && exports !== null ? exports : null;

  if (global == null) {
    throw new ReferenceError("Unable to find global object.");
  }

  constructǃ = function construct(theThis, constructor, type) {
    if (theThis == null) {
      throw new TypeError("".concat(type, " must be called as a constructor."));
    }

    if (!(theThis instanceof constructor)) {
      throw new TypeError("This is not a ".concat(type, "."));
    }
  };

  Ø = function _() {
    var identifier = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : "anonymous";
    var prototype = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : Object.prototype;
    var obj;
    obj = _defineProperty({}, identifier, function () {
      throw new TypeError("Illegal constructor.");
    });
    return Object.defineProperty(obj[identifier], "prototype", {
      configurable: false,
      value: prototype,
      writable: false
    });
  };

  Object.defineProperty((Kyrie = function Kyrie() {}).prototype, "constructor", {
    configurable: false,
    value: Ø("Kyrie", Kyrie.prototype),
    writable: false
  });
  kyrie = new Kyrie();
  Object.defineProperties(global, {
    kyrie: {
      configurable: true,
      value: kyrie
    },
    "🌄🎼": {
      configurable: true,
      value: kyrie
    }
  });
  Object.defineProperties(kyrie, {
    ℹ: {
      value: "https://go.KIBI.family/Kyrie/"
    },
    Nº: {
      value: Object.freeze({
        major: 0,
        minor: 0,
        patch: 0,
        toString: function toString() {
          return "".concat(this.major, ".").concat(this.minor, ".").concat(this.patch);
        },
        valueOf: function valueOf() {
          return this.major * 100 + this.minor + this.patch / 100;
        }
      })
    }
  });
}).call(void 0);
