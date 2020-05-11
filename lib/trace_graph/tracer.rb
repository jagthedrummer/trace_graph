module TraceGraph
  class Tracer
    def initialize(options)
      @options = options
      @trace_point = build_trace_point
      @top_nodes = []
      @stack = []
      @all_nodes = []
    end

    def trace
      unless block_given?
        raise Error.new "You must pass a block to the tracer."
      end
      @trace_point.enable
      yield
      @trace_point.disable
    end

    def call_trace
      @top_nodes
    end

    def node_count
      @all_nodes.length
    end

    private

    def build_trace_point
      TracePoint.new(:call,:return) do |tp|
        if tp.event == :call
          handle_call(tp)
        elsif tp.event == :return
          handle_return(tp)
        end
      end
    end

    def handle_call(tp)
      parent = @stack.last
      new_node = TraceGraph::TraceNode.new("#{tp.defined_class}##{tp.method_id}")
      @stack << new_node
      @all_nodes << new_node
      if parent
        parent << new_node
      else
        @top_nodes << new_node
      end
    end

    def handle_return(tp)
      puts "handle_return"
      @stack.pop
    end
  end
end
