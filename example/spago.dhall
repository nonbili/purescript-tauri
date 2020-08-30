{ name = "example"
, dependencies =
  [ "aff-promise", "argonaut-codecs", "console", "effect", "psci-support" ]
, packages = ./packages.dhall
, sources = [ "../src/**/*.purs", "src/**/*.purs" ]
}
