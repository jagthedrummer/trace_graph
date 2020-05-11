module TraceGraph
  class Tracer
    def initialize(options)
      @options = options
      # We check included paths differently than excluded ones to allow nil to be bassed, to include everyting
      @included_paths = options.key?(:included_paths) ? options[:included_paths] : []
      @excluded_paths = options[:excluded_paths] || []
      @include_protected = options[:include_protected] || false
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
