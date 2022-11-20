# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"
require_relative "vandalay/version"
require_relative "vandalay/compiler"

module Vandalay
  class Error < StandardError; end

  autoload :Compiler, "vandalay/compiler"
  autoload :Runtime, "vandalay/runtime"
end
