RSpec.describe TraceGraph::Tracer do

  require 'support/foo'

  it "generates a basic graph if paths are matched" do
    foo = Foo.new
    tracer = TraceGraph::Tracer.new({ included_paths: ["foo"] })
    tracer.trace{ foo.foo_both }
    expect(tracer.node_count).to eq(3)
    expect(tracer.call_trace.first.node_count).to eq(2)
  end

  it "generates a basic graph if included_paths is nil" do
    foo = Foo.new
    tracer = TraceGraph::Tracer.new({ included_paths: nil })
    tracer.trace{ foo.foo_both }
    expect(tracer.node_count).to eq(3)
    expect(tracer.call_trace.first.node_count).to eq(2)
  end

  it "generates an empty graph if no paths are matched" do
    foo = Foo.new
    tracer = TraceGraph::Tracer.new({ included_paths: [] })
    tracer.trace { foo.foo_both }
    expect(tracer.node_count).to eq(0)
  end

  it "generates an empty graph if included_paths is nil but the path is excluded" do
    foo = Foo.new
    tracer = TraceGraph::Tracer.new({ included_paths: nil, excluded_paths: ["foo"] })
    tracer.trace{ foo.foo_both }
    expect(tracer.node_count).to eq(0)
  end
end
