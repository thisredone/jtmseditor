class Justification < Node

  def initialize id, pos
    super
    @in_list = @out_list = []
    @radius = 40
    @points = [ [@pos[0]+40, @pos[1]],
                [@pos[0]-28, @pos[1]-28],
                [@pos[0]-28, @pos[1]+28],
                [@pos[0]-30, @pos[1]] ].map{|x| x.map &:to_f}
  end

  def draw
    stroke @border
    no_fill
    ellipse *@pos + [80, 80]
    fill 255, 255, 255
    triangle *@points[0..2].flatten
    text_align CENTER, CENTER
    fill 0, 0, 0
    text id.to_s, *@pos
  end

end