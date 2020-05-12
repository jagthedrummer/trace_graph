class Bar
  def do_foo_bar
    foo = Foo.new
    foo.foo_both
    do_bar
    foo.foo_both_with_private
  end

  def do_bar
  end
end
