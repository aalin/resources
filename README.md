# import/export for ruby

This repo contains some experiments with modules,
inspired by ES-modules and Rollup.

Plugins are used to resolve paths, load files,
resolve imports and transform source code.

`Resources::Compiler#compile` returns a hash of `Resources::ResourceInfo`
which can be marshaled, and later unmarshaled into `Resources::Runtime`
to run the same code later without having to transform everything again.
