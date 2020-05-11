RSpec.describe TraceGraph::Tracer do

  require 'support/foo'

  it "generates a basic graph" do
    foo = Foo.new
    tracer = TraceGraph::Tracer.new({})
    tracer.trace do
      foo.foo_both
    end
    expect(tracer.node_count).to eq(3)
    expect(tracer.call_trace.first.node_count).to eq(2)
  end

end
