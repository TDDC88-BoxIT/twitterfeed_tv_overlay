-- This method uses a sprite to render text to the GUI
function render_text(text, x_start, y_start, max_width, text_size, text_surface)
print("text")
dir = 'scrum1/static/img/'
local text_sprite = gfx.loadpng(dir .. 'text_sprite.png')
x_pos = x_start
y_pos = y_start
char_width=10*text_size
char_height=12*text_size
line_spacing=5
list_of_words,l = split_word_to_list(text)
print(l)
for i=1,l do
  if(line_too_wide(x_pos, list_of_words[i], max_width)) then do
    x_pos,y_pos = break_line
  end
  write_word(list_of_words[i], x_pos, y_pos, char_width, char_height, text_surface)
end

--Make sure to destroy the sprite in order to conserve RAM
end
end
--Determines whether to break line or not. Looks at current x_pos, length of word and max_with
function line_too_wide(x_pos, next_word, max_width)
  break_line = false
  return break_line
end

--If the line witdh is greater than max_with, this function is called to break the line
function break_line(x_start, y_start)
  return x_pos,y_pos
end

--Writes one single word, gets input where to put it 
function write_word(word ,x_pos, y_pos, char_width, char_height, text_surface)
  for i=1,string.len(word) do
    --The values in this line is based on the width of 
    --a char in the sprite (39), the height (47), the 
    --number of columns of char (26). The characters 
    --in the sprite are arranged in increasing order of
    --value of the character. The strating value is " " = 32 
    text_surface:copyfrom(text_sprite, {x=(((string.byte(string.sub(word,i,i))-32)%26)*39), y=(math.floor((string.byte(string.sub(word,i,i))-32)/26)*46), w=40, h=47}, {x = x_pos , y = y_pos, w = char_width , h = char_height} ,true)
    x_pos=x_pos+(4*char_width/5)
  end
end

--Splits the incoming string to list in order to write the text word-by-word
--This makes line break testing much easier.
function split_word_to_list( text )
  list_of_words = {}
  l=1
  for i in string.gmatch(text, "%S+") do
    list_of_words[l] = i
    l = l+1
  end
  return list_of_words, l-1
end