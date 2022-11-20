# Vandalay

## Description

This library is an expriement with a module system with import/export.

Plugins are used to resolve paths, load files, resolve imports and
transform source code.

`Vandalay::Compiler#compile` returns a hash of `Vandalay::ResourceInfo`
which can be marshaled, and later unmarshaled into `Vandalay::Runtime`
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

