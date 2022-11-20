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

### Default exports

```ruby
class Foo
  def hello
    puts "hello"
  end
end

export default: Foo
```

This class can be imported like this:

```ruby
Foo = import("./foo.rb")
```

### Named exports

```ruby
class Foo
end

class Bar
end

BAZ = "baz"

export Foo
export Bar, BAZ:
```

is the same as:

```ruby
class Foo
end

class Bar
end

BAZ = "baz"

export(
  Foo:,
  Bar:,
  BAZ:,
)
```

and can be imported like this:

```ruby
Foo, Bar, BAZ = import("module.rb", :Foo, :Bar, :BAZ)
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
