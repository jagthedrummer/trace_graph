class Foo
  def foo1
    puts "calling foo1"
  end

  def foo2
    puts "calling foo2"
  end

  def foo_both
    foo1
    foo2
  end

  def foo_both_with_private
    foo1
    foo_private
    foo2
  end

  private

  def foo_private
    puts "calling foo_private"
  end
end
