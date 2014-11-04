-- This method uses a sprite to render text to the GUI
function render_text(text, x_pos, y_pos, max_width, max_height)
dir = 'scrum1/static/img/'
local text_sprite = gfx.loadpng(dir .. 'text_sprite.png')
x_rel = x_pos
y_rel = y_pos
char_width=40
char_height=40
line_spacing=5
	for i=1,string.len(text) do
    screen:copyfrom(text_sprite, {x=(((string.byte(string.sub(text,i,i))-32)%25)*39), y=(math.floor((string.byte(string.sub(text,i,i))-31)/25)*46), w=40, h=47}, {x = x_rel , y = y_rel, w = char_width , h = char_height} ,true)
    x_rel=x_rel+char_width
    if (x_rel>= max_width) then
      y_rel=(y_rel+char_height)
      x_rel=x_pos
    end
  end
end

function onStart()
  render_text(, 50, 50, 400)
end
