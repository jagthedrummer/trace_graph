RSpec.describe TraceGraph::Tracer do

  require 'support/foo'
  require 'support/bar'

  it "generates a basic graph if paths are matched" do
    foo = Foo.new
    tracer = TraceGraph::Tracer.new({ included_paths: ["foo"] })
    tracer.trace{ foo.foo_both }
    expect(tracer.node_count).to eq(3)
    expect(tracer.call_trace.first.node_count).to eq(2)
  end

  it "generates an even more basic graph if paths are matched and only_class_transitions is true" do
    bar = Bar.new
    tracer = TraceGraph::Tracer.new({ included_paths: ["spec/support"], only_class_transitions: true })
    tracer.trace{ bar.do_foo_bar }
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

  it "excluded private methods by default" do
    foo = Foo.new
    tracer = TraceGraph::Tracer.new({ included_paths: nil })
    tracer.trace{ foo.foo_both_with_private }
    expect(tracer.node_count).to eq(3)
    expect(tracer.call_trace.first.node_count).to eq(2)
  end

  it "can include protected methods" do
    foo = Foo.new
    tracer = TraceGraph::Tracer.new({ included_paths: nil, include_protected: true })
    tracer.trace{ foo.foo_both_with_private }
    expect(tracer.node_count).to eq(4)
    expect(tracer.call_trace.first.node_count).to eq(3)
  end

  it "generates an empty graph if included_paths is nil but the path is excluded" do
    foo = Foo.new
    tracer = TraceGraph::Tracer.new({ included_paths: nil, excluded_paths: ["foo"] })
    tracer.trace{ foo.foo_both }
    expect(tracer.node_count).to eq(0)
  end

  it "can trace multiple calls in the block" do
    foo = Foo.new
    tracer = TraceGraph::Tracer.new({ included_paths: nil, include_protected: true })
    tracer.trace do
      foo.foo_both
      foo.foo_both_with_private
    end
    expect(tracer.node_count).to eq(7)
  end

  it "generates a png" do
    foo = Foo.new
    png = "tmp/trace_graph.png"
    tracer = TraceGraph::Tracer.new({ included_paths: ["foo"], png: png, mark_duplicate_calls: true, include_protected: true })
    tracer.trace do
      foo.foo_both
      foo.foo_both_with_private
    end
    expect(tracer.node_count).to eq(7)
    expect(tracer.call_trace.first.node_count).to eq(2)
    expect(tracer.call_trace.second.node_count).to eq(3)
  end

  it "generates a png without marking duplicates" do
    foo = Foo.new
    png = "tmp/trace_graph_without_duplicates.png"
    tracer = TraceGraph::Tracer.new({ included_paths: ["foo"], png: png, mark_duplicate_calls: false, include_protected: true })
    tracer.trace do
      foo.foo_both
      foo.foo_both_with_private
    end
    expect(tracer.node_count).to eq(7)
    expect(tracer.call_trace.first.node_count).to eq(2)
    expect(tracer.call_trace.second.node_count).to eq(3)
  end
end
