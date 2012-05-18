class Justification < Node

  attr_accessor :pos
  attr_reader :radius, :id

  def initialize id, pos
    super
    @in_list = @out_list = []
    @radius = 40
  end

  def draw
    stroke @border
    no_fill
    ellipse *@pos + [80, 80]
    fill 255, 255, 255
    triangle *[@pos[0]+40, @pos[1]] +
              [@pos[0]-28, @pos[1]-28] +
              [@pos[0]-28, @pos[1]+28]
  end

end