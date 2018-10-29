{ expect } = require "chai"
global = require "../Build/Kyrie.js"

describe "kyrie", ->

  it "exists", ->
    expect global
      .has.ownProperty "kyrie"

  it "can't be constructed", ->
    proto = Object.getPrototypeOf global.kyrie
    expect proto.constructor
      .throws
    expect -> new proto.constructor
      .throws

  it "is available from 🌄🎼 sigil", ->
    expect global
      .has.ownProperty "🌄🎼"
      .which.equals global.kyrie

  describe "§ Identity", ->
    { kyrie } = global
    packageVersion = process.env.npm_package_version
    [ major, minor, patch ] = packageVersion.split "."

    it "has the correct API ID", ->
      expect kyrie
        .has.ownProperty "ℹ"
        .which.equals "https://go.KIBI.family/Kyrie/"
    it "has the correct version", ->
      expect kyrie
        .has.ownProperty "Nº"
      expect kyrie.Nº
        .has.ownProperty "major"
        .which.equals +major
      expect kyrie.Nº
        .has.ownProperty "minor"
        .which.equals +minor
      expect kyrie.Nº
        .has.ownProperty "patch"
        .which.equals +patch
      expect "#{kyrie.Nº}"
        .equals packageVersion
      expect +kyrie.Nº
        .equals +major * 100 + +minor + +patch / 100

  describe "§ Constants", ->
    { kyrie } = global


  describe "§ Properties", ->
    { kyrie } = global
