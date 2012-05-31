class Edge
  include Processing::Proxy

  attr_reader :nodes

  def initialize node1, node2
    @nodes = [node1, node2]
    @nagation = false
  end

  def negate
    @negation = !@negation
  end

  def draw
    stroke 255, 255, 255
    line *@nodes[0].out_point+@nodes[1].in_point
    ellipse *@nodes[0].out_point + [8, 8] if @negation
  end

end