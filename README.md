# import/export for ruby

## Description

This repo contains some experiments with modules,
inspired by ES-modules and Rollup.

Plugins are used to resolve paths, load files,
resolve imports and transform source code.

`Resources::Compiler#compile` returns a hash of `Resources::ResourceInfo`
which can be marshaled, and later unmarshaled into `Resources::Runtime`
to run the same code later without having to transform everything again.

## Usage

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

