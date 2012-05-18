class Node
  include Processing::Proxy

  def initialize id, pos
    @id = id
    @pos = pos
    @connections = connections
    @border = color(0, 0, 0)
  end

  def draw
  end

  def select
    @border = color(100, 100, 100)
  end

  def clear_selection
    @border = color(0, 0, 0)
  end

end