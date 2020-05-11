class Foo
  def foo1(keyword_arg: nil)
    puts "calling foo1"
    return { wat: "foo1" }
  end

  def foo2(arg = nil, arg2 = 'wow')
    puts "calling foo2"
  end

  def foo_both
    foo1(keyword_arg: 1)
    foo2('bar')
  end

  def foo_both_with_private
    foo1(keyword_arg: 1)
    foo_private
    foo2('baz')
  end

  private

  def foo_private
    puts "calling foo_private"
  end
end
