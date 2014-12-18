#encoding: utf-8
require 'minitest/autorun'
require 'pry'
require_relative '../lib/code_reload'

class MainTest < Minitest::Test
  def test_free
    binding.pry
  end
end
