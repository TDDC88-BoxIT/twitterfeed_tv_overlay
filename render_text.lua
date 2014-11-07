-- This method uses a sprite to render text to the GUI
function render_text(text, x_pos, y_pos, max_width, text_size, text_surface)
dir = 'scrum1/static/img/'
local text_sprite = gfx.loadpng(dir .. 'text_sprite.png')
x_rel = x_pos
y_rel = y_pos
char_width=10*text_size
char_height=12*text_size
line_spacing=5
	for i=1,string.len(text) do
    --The values in this line is based on the width of 
    --a char in the sprite (39), the height (47), the 
    --number of columns of char (26). The characters 
    --in the sprite are arranged in increasing order of
    --value of the character. The strating value is " " = 32 
    text_surface:copyfrom(text_sprite, {x=(((string.byte(string.sub(text,i,i))-32)%26)*39), y=(math.floor((string.byte(string.sub(text,i,i))-32)/26)*46), w=40, h=47}, {x = x_rel , y = y_rel, w = char_width , h = char_height} ,true)
    x_rel=x_rel+(2*char_width/3)
    if (x_rel>= max_width) then
      y_rel=(y_rel+char_height+line_spacing)
      x_rel=x_pos
    end
  end
--Make sure to destroy the sprite in order to conserve RAM
text_sprite:destroy()
end

--This method is used to check whether to break line or not
function break_line(max_width, line_width)

end

--onStart for testing purposes
function onStart()
  render_text("Lorem ipsum stuff stuff, I am writing text to test if it looks good", 50, 50, 800, 2)
end