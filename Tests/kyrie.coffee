{ expect } = require "chai"
global = require "../Build/Kyrie.js"

describe "kyrie", ->

  it "exists", ->
    (expect global).has.ownProperty "kyrie"

  it "can't be constructed", ->
    proto = Object.getPrototypeOf global.kyrie
    (expect proto.constructor).throws
    (expect -> new proto.constructor).throws

  it "is available from 🌄🎼 sigil", ->
    (expect global).has.ownProperty "🌄🎼"
    (expect global["🌄🎼"]).equals global.kyrie

  describe "§ Identity", ->
    { kyrie } = global
    packageVersion = process.env.npm_package_version
    [ major, minor, patch ] = packageVersion.split "."

    it "has the correct API ID", ->
      (expect kyrie).has.ownProperty "ℹ"
      (expect kyrie.ℹ).equals "
        https://go.KIBI.family/Kyrie/
      "
    it "has the correct version", ->
      (expect kyrie).has.ownProperty "Nº"
      (expect kyrie.Nº).has.ownProperty "major"
      (expect kyrie.Nº.major).equals +major
      (expect kyrie.Nº).has.ownProperty "minor"
      (expect kyrie.Nº.minor).equals +minor
      (expect kyrie.Nº).has.ownProperty "patch"
      (expect kyrie.Nº.patch).equals +patch
      (expect "#{kyrie.Nº}").equals packageVersion
      (expect +kyrie.Nº).equals +major * 100 + (+minor) +
        +patch / 100

  describe "§ Constants", ->
    { kyrie } = global


  describe "§ Properties", ->
    { kyrie } = global
