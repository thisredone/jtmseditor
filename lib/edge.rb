class Edge
  include Processing::Proxy

  attr_reader :nodes

  def initialize node1, node2
    @nodes = [node1, node2]
  end

  def draw
    stroke 255, 255, 255
    line *@nodes.map(&:pos).flatten
  end

end