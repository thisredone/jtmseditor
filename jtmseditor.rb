Dir['lib/*.rb'].reverse.each { |x| require x }

class Jtmseditor < Processing::App

  def setup
    @counter = 0
    @current_object = Justification
    @objects = []
    size 1024, 768
    smooth
    stroke_weight 2
    stroke 255, 255, 255
    @drag = nil
    @select = nil
    @edges = []
  end
  
  def draw
    background 51
    @edges.each &:draw
    @objects.each &:draw
    text_align LEFT, BASELINE
    fill 230, 255, 250
    text 'Zmiana elementu : PPM', 10, 15
    text 'Umieszczenie/zaznaczanie elementu : LPM', 10, 30
    text 'Krawędź : zaznacz + Ctrl + LPM', 10, 45
    text 'Przemieszczanie : przytrzymaj LPM', 10, 60
    text 'Usuwanie : zaznacz + del', 10, 75
    text 'Obracanie : zaznacz + alt + przeciągnij w poziomie', 10, 90
    text 'Negacja : zaznacz + Shift + LPM', 10, 105
    text 'Zmien OUT/IN : zaznacz + q', 10, 120
    text 'Zapis do pliku save.ntwk : s', 10, 135
    text 'Odczyt z pliku save.ntwk : l', 10, 150
    text 'Eksport do pliku output.pl : e', 10, 165
    text 'Import z pliku input.txt : i', 10, 180
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
      if key_pressed? && found != @select
        connect @select, found if key_code == 17
        negate @select, found if key_code == 16
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
    if key_pressed? && key_code == 18 && @select
      return @select.rotate(mouse_x-pmouse_x)
    end
    mpos = [mouse_x, mouse_y]
    return @drag.pos = mpos if @drag
    if (found = search mpos)
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
    case key_code
    when 127
      @objects.delete @select
      @edges.delete_if { |x| x.nodes.include? @select }
      @drag = @select = nil
    when 81
      @select.switch if @select.class == Assertion
    when 83
      save_file
    when 76
      load_file
    when 69
      export_file
    when 73
      import_file
    end
  end

  def connect obj1, obj2
    found = @edges.find { |x| x.nodes == [obj1, obj2] }
    return @edges.delete found if found
    @edges << Edge.new(obj1, obj2)
  end

  def negate obj1, obj2
    found = @edges.find { |x| x.nodes == [obj1, obj2] }
    @edges << (found = Edge.new(obj1, obj2)) if !found
    found.negate
  end

  def export_file
    output = ''
    nodes = @objects.select { |x| x.class == Assertion }
    nodes_attr = nodes.map { |x| x.in? ? 1 : 0 }
    output << "nodes([#{nodes.map(&:id).join(',')}],[#{nodes_attr.join(',')}]).\n"
    @edges.group_by { |x| x.nodes[1] }.map do |node, edges|
      ins = edges.map { |x| x.nodes[0].id }.join ','
      negs = edges.map { |x| x.negated? ? '1' : '0' }.join ','
      "bramka(#{node.id},[#{ins}],[#{negs}]).\n"
    end.each { |x| output << x }
    @objects.select { |x| !@edges.find { |e| e.nodes[1] == x } }.each do |node|
      output << "bramka(#{node.id},[],[]).\n"
    end
    File.open('output.pl', 'w') { |f| f << output }
  rescue
    puts 'not saved'
  end

  def import_file
    input = File.read 'input.txt'
    input.split("\n").map { |x| x.split(' ') }.each do |id, state|
      node = @objects.find { |x| x.id == id.to_i }
      node.switch if node && node.state != state rescue nil
    end
  rescue
    puts 'not loaded'
  end

  def save_file
    File.open('save1.ntwk', 'w') do |f|
      f << Marshal.dump([@objects, @edges, @counter])
    end
  rescue
  end

  def load_file
    @objects, @edges, @counter = Marshal.load File.read 'save1.ntwk'
  rescue
  end

end
