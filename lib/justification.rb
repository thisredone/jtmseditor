class Justification < Node

  attr_reader :pos
  attr_reader :radius, :id

  def initialize id, pos
    super
    @in_list = @out_list = []
    @radius = 40
    @points = [ [@pos[0]+40, @pos[1]],
                [@pos[0]-28, @pos[1]-28],
                [@pos[0]-28, @pos[1]+28],
                [@pos[0]-30, @pos[1]] ].map{|x| x.map &:to_f}
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