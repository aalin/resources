# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"
require_relative "vandelay/version"
require_relative "vandelay/compiler"

module Vandelay
  class Error < StandardError
  end

  autoload :Compiler, "vandelay/compiler"
  autoload :Runtime, "vandelay/runtime"
end
