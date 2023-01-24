# Vandelay

## Description

This library is an expriement with a module system with import/export.

Plugins are used to resolve paths, load files, resolve imports and
transform source code.

`Vandelay::Compiler#compile` returns a hash of `Vandelay::ResourceInfo`
which can be marshaled, and later unmarshaled into `Vandelay::Runtime`
to run the same code later without having to transform everything again.

Inspired by [ES-modules](https://tc39.es/ecma262/#sec-modules) and
[Rollup](https://rollupjs.org/).

## Usage

### Export

```ruby
class Foo
  def hello
    puts "hello"
  end
end

Export = Foo
```

This class can be imported like this:

```ruby
Foo = import("./foo.rb")
```

### Multiple exports

```ruby
module Export
  class Foo
  end

  class Bar
  end

  BAZ = "baz"
end
```

and can be imported like this:

```ruby
MyModule = import("module.rb")
MyModule::Foo
```

## Notes

It's not possible to use Sorbet in these modules.

It might be possible to generate RBS-files for each module using
[parlour](https://github.com/AaronC81/parlour).

`import` would have to be overloaded for each module, and each
imported path must be mapped to an id, so that the RBI-generator
can resolve the exports for that module.

However, this approach would require saving a module after
changing imports to regenerate the RBI. It would be awesome
if there was a way to get Sorbet to run a method that could
resolve imports while editing, but I don't think there is.
