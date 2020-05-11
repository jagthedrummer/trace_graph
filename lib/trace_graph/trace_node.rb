module TraceGraph
  class TraceNode
    attr_accessor :label
    attr_accessor :sub_nodes

    def initialize(label)
      self.label = label
      self.sub_nodes = []
    end

    def << child_node
      sub_nodes << child_node
    end

    def node_count
      sub_nodes.length
    end
  end
end
