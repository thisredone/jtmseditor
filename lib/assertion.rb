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
    @status == :OUT?
  end

  def draw
    stroke @border
    fill 255, 255, 255
    ellipse *@pos + [@radius*2, @radius*2]
    text_align CENTER, CENTER
    fill 0, 0, 0
    text id.to_s, *@pos
  end

end