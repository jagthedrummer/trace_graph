class Foo
  def first_method(keyword_arg: nil)
    #puts "calling first_method"
    return { wat: "first_method" }
  end

  def second_method(arg = nil, arg2 = 'wow')
    #puts "calling second_method"
  end

  def foo_both
    first_method(keyword_arg: 1)
    second_method('bar')
  end

  def foo_both_with_private
    first_method(keyword_arg: 1)
    private_method
    second_method('baz')
  end

  private

  def private_method
    #puts "calling private_method"
  end
end
