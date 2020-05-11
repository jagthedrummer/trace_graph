module TraceGraph
  class Tracer
    require 'ruby-graphviz'

    def initialize(options)
      @options = options
      # We check included paths differently than excluded ones to allow nil to be bassed, to include everyting
      @included_paths = options.key?(:included_paths) ? options[:included_paths] : []
      @excluded_paths = options[:excluded_paths] || []
      @include_protected = options[:include_protected] || false
      @mark_duplicate_calls = options.key?(:mark_duplicate_calls) ? options[:mark_duplicate_calls] : true

      @trace_point = build_trace_point
      @top_node = TraceGraph::TraceNode.new("trace")
      @stack = []
      @all_nodes = [@top_node]
      @edge_count = 0
      @unique_node_counts = {}
    end

    def trace
      unless block_given?
        raise Error.new "You must pass a block to the tracer."
      end

      @edge_count = 0
      @unique_node_counts = {}
      @trace_point.enable
      yield
      @trace_point.disable
      # TODO : Maybe outputting this should be an options, or a different tracer?
      puts @top_node.tree_graph
      if @options[:png]
        write_png @options[:png]
      end
    end

    def call_trace
      @top_node
    end

    def node_count
      @all_nodes.length - 1 # should top_node count as a node?
    end

    private

    def write_png png
      g = ::GraphViz.new( :G, :type => :digraph )
      add_node g, @top_node, nil
      g.output( :png => png )
    end

    def add_node graph, node, parent
      label = node.label
      gnode = graph.add_nodes(label)
      if node.is_duplicate
        gnode[:color] = "red:white"
      end
      if parent
        edge = graph.add_edges(parent.label, label)
        edge[:label] = @edge_count + 1
        @edge_count += 1
        # add edge
      end
      node.sub_nodes.each do |sub_node|
        add_node graph, sub_node, node
      end
    end

    def build_trace_point
      TracePoint.new(:call,:return) do |tp|
        if should_include_trace_line(tp)
          if tp.event == :call
            handle_call(tp)
          elsif tp.event == :return
            handle_return(tp)
          end
        end
      end
    end

    def handle_call(tp)
      parent = @stack.last
      label = "#{tp.defined_class}##{tp.method_id}"
      is_dupicate = false
      if @mark_duplicate_calls
        if @unique_node_counts[label]
          @unique_node_counts[label] += 1
        else
          @unique_node_counts[label] = 0
        end
        if @unique_node_counts[label] > 0
          label = "#{label} (##{@unique_node_counts[label]+1})"
          is_duplicate = true
        end
      end
      new_node = TraceGraph::TraceNode.new(label, is_duplicate: is_duplicate)
      @stack << new_node
      @all_nodes << new_node
      if parent
        parent << new_node
      else
        @top_node << new_node
      end
    end

    def handle_return(tp)
      @stack.pop
    end

    def should_include_trace_line(tp)
      should_include = false
      if @included_paths
        @included_paths.each do |path|
          path = path.is_a?(String) ? /#{path}/ : path
          if tp.inspect =~ path
            should_include = true
          end
        end
      else
        # If included_paths was passed as nil that means to include everything that's not excluded
        should_include = true
      end
      @excluded_paths.each do |path|
        path = path.is_a?(String) ? /#{path}/ : path
        if tp.inspect =~ path
          should_include = false
        end
      end
      klass = tp.defined_class
      method = tp.method_id
      public_methods = klass.public_methods(false) + klass.public_instance_methods(false)
      unless public_methods.include?(method) || @include_protected
        should_include = false
      end
      return should_include
    end
  end
end
