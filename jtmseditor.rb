Dir['lib/*.rb'].reverse.each &method(:require)

class Jtmseditor < Processing::App

  def setup
    @counter = 0
    @current_object = Justification
    @objects = []
    smooth
    stroke_weight 2
    stroke 255, 255, 255
    @drag = nil
    @select = nil
    @edges = []
  end

  def update
  end
  
  def draw
    update
    background 51
    @edges.each &:draw
    @objects.each &:draw
    text_align LEFT, BASELINE
    fill 230, 255, 250
    text 'Zmiana elementu : PPM', 10, 15
    text 'Umieszczenie elementu : LPM', 10, 30
    text 'Krawędź : CTRL + LPM', 10, 45
    text 'Przemieszczanie elementów : przytrzymaj LPM', 10, 60
  end

  def mouse_released
    @drag = nil
  end

  def mouse_clicked
    if mouse_button == 39
      @current_object = @current_object == Justification ? Assertion : Justification
      return
    end
    if (found = search [mouse_x, mouse_y])
      if key_pressed? && key_code == 17 && found != @select
        connect @select, found
      else
        select found
      end
      return
    end
    @objects << @current_object.new(@counter, [mouse_x, mouse_y])
    select @objects.last
    @counter += 1
  end

  def mouse_dragged
    return unless mouse_button == 37
    mpos = [mouse_x, mouse_y]
    found = search mpos
    if found
      (@drag ||= found).pos = mpos
      select @drag
    else
      @objects << @current_object.new(@counter, [mouse_x, mouse_y])
      select @objects.last
      @counter += 1
    end
  end

  def search pos
    @objects.find do |obj|
      obj.radius > Math.sqrt(obj.pos.zip(pos).map{|x,y|(x-y).abs}.inject{|x,y| x*x+y*y})
    end
  end

  def select obj
    @select.clear_selection if @select
    (@select = obj).select
  end

  def key_pressed
    if key_code == 127
      @objects.delete @select
      @edges.delete_if { |x| x.nodes.include? @select }
      @drag = @select = nil
    end
  end

  def connect obj1, obj2
    found = @edges.find do |x| 
      x.nodes == [obj1, obj2] ||
      x.nodes == [obj2, obj1]
    end
    if found
      @edges.delete found
      return
    end
    @edges << Edge.new(obj1, obj2)
  end

end

Jtmseditor.new :title => "Jtmseditor", :width => 800, :height => 600