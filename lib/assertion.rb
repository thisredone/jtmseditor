class Assertion < Node

  attr_accessor :pos
  attr_reader :radius, :id
  
  def initialize id, pos
    super
    @status = nil
    @radius = 40
  end

  def in?
    @status == :IN?
  end

  def out?
    !in?
  end

  def draw
    stroke @border
    ellipse *@pos + [@radius*2, @radius*2]
  end

end