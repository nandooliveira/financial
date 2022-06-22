# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/hello_world'

class HelloWorldTest < Minitest::Test
  def test_coolness_of_hello
    assert_equal HelloWorld.new.coolness, 11
  end
end
