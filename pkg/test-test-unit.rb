require 'test/unit'
class A < Test::Unit::TestCase
  def test_a
    assert true
    assert_equal(1,1)
    false  #Not caught by testing framework.
  end
end
class B
  def test_b  #Not run by testing framework.
    puts 'hello'
  end
end
