require 'tree_graph'

module TraceGraph
  class TraceNode
    include TreeGraph
    attr_accessor :label
    attr_accessor :sub_nodes
    attr_accessor :is_duplicate

    alias_method :label_for_tree_graph, :label
    alias_method :children_for_tree_graph, :sub_nodes

    def initialize(label, is_duplicate: false)
      self.label = label
      self.is_duplicate = is_duplicate
      self.sub_nodes = []
    end

    def << child_node
      sub_nodes << child_node
    end

    def node_count
      sub_nodes.length
    end

    def first
      sub_nodes.first
    end
  end
end
