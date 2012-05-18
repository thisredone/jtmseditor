Dir['lib/*.rb'].reverse.each &method(:require)

class Jtmseditor < Processing::App

  def setup
    @counter = 0
    @current_object = Justification
    @objects = []
    smooth
    stroke_weight 2
    @drag = nil
    @select = nil
  end

  def update
  end
  
  def draw
    update
    background 51
    @objects.each &:draw
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
      @drag = @select = nil
    end
  end

  def connect obj1, obj2
    
  end

end

Jtmseditor.new :title => "Jtmseditor", :width => 800, :height => 600