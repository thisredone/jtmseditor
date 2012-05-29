class Node
  include Processing::Proxy

  attr_reader :radius, :id, :pos
  
  def initialize id, pos
    @id = id
    @pos = pos
    @border = color(0, 0, 0)
    @points = []
  end

  def pos= x
    @points.map! { |p| [p[0]+(x[0]-pos[0]), p[1]+(x[1]-@pos[1])] }
    @pos = x
  end

  def rotate angle
    rad = angle.to_f/180*Math::PI
    sin, cos = Math.sin(rad), Math.cos(rad)
    @points.map! do |p|
      p = [p[0]-@pos[0], p[1]-@pos[1]]
      [(p[0]*cos-p[1]*sin)+@pos[0], (p[0]*sin+p[1]*cos)+@pos[1]]
    end
  end

  def in_point
    @points.last
  end

  def out_point
    @points.first
  end

  def draw; end

  def select
    @border = color(100, 100, 100)
  end

  def clear_selection
    @border = color(0, 0, 0)
  end

end