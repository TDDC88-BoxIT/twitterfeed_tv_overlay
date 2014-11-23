-- This method uses a sprite to render text to the GUI
function render_text(text, x_start, y_start, max_width, text_size, text_surface)

dir = 'scrum1/static/img/'
local text_sprite = gfx.loadpng(dir .. 'text_sprite_courier.png')
a_med_prickar = gfx.loadpng(dir .. 'a_med_prickar.png')
a_med_cirkel = gfx.loadpng(dir .. 'a_med_cirkel.png')
o_med_prickar = gfx.loadpng(dir .. 'o_med_prickar.png')
x_pos = x_start
y_pos = y_start
char_width=10*text_size
char_height=15*text_size
line_spacing=5
word_max_width = max_width
list_of_words,l = split_word_to_list(text)

--print(l)
  for i=1,l do
    if(line_too_wide(x_pos, list_of_words[i], max_width) and string.len(list_of_words[i])*char_width < max_width) then 
      x_pos,y_pos = break_line(x_start, y_pos)
    end
    x_pos = write_word(list_of_words[i], x_pos, y_pos, char_width, char_height, text_surface, text_sprite)
  end

--Make sure to destroy the sprite in order to conserve RAM
end

--Determines whether to break line or not. Looks at current x_pos, length of word and max_with
function line_too_wide(x_pos, next_word, max_width)
  if (string.len(next_word)*char_width+x_pos) > max_width then
    break_line1 = true
  else
    break_line1 = false
  end
  return break_line1
end

--If the line witdh is greater than max_with, this function is called to break the line
function break_line(x_start, y_pos)
  return x_start,y_pos+char_height+line_spacing
end

--Writes one single word, gets input where to put it 
function write_word(word ,x_pos, y_pos, char_width, char_height, text_surface, text_sprite)
  for i=1,string.len(word) do
    --The values in this line is based on the width of 
    --a char in the sprite (39), the height (47), the 
    --number of columns of char (26). The characters 
    --in the sprite are arranged in increasing order of
    --value of the character. The strating value is " " = 32 
    if string.byte(string.sub(word,i,i),1,1) == 195 then
    
    else
      if string.byte(string.sub(word,i,i),1,1) == 165 then
      text_surface:copyfrom(a_med_cirkel, {x=12, y=3, w = 23, h = 42}, { x= x_pos, y = y_pos, w = char_width, h = char_height}, true)
      elseif string.byte(string.sub(word,i,i),1,1) == 164 then
      text_surface:copyfrom(a_med_prickar, {x=11, y=8, w = 23, h = 38}, { x= x_pos, y = y_pos, w = char_width, h = char_height}, true)
      elseif string.byte(string.sub(word,i,i),1,1) == 182 then
      text_surface:copyfrom(o_med_prickar, {x=10, y=8, w = 24, h = 37}, { x= x_pos, y = y_pos, w = char_width, h = char_height}, true)
    else
    text_surface:copyfrom(text_sprite, {x=((string.byte(string.sub(word,i,i))-32)*49), y=12, w = 49, h = 67}, { x= x_pos, y = y_pos, w = char_width, h = char_height}, true)--(math.floor((string.byte(string.sub(word,i,i))-32)/94)*25), w=40, h=47}, {x = x_pos , y = y_pos, w = char_width , h = char_height} ,true)
    end
    --x_pos=x_pos+(4*char_width/5)
    x_pos=x_pos+char_width
    end
  end
  x_pos=x_pos+char_width

  return x_pos
end

--Splits the incoming string to list in order to write the text word-by-word
--This makes line break testing much easier.
function split_word_to_list(text)
  list_of_words = {}
  l=1
  for i in string.gmatch(text, "%S+") do
    local word_divider = math.ceil((string.len(i)*char_width) / word_max_width)
    if word_divider > 1 then
      for x = 1, word_divider do
        if x == 1 then          
          list_of_words[l] = string.sub(i,1, x*math.floor(string.len(i)/word_divider))
          l = l+1
        elseif x == word_divider then
          list_of_words[l] = string.sub(i,1+(x-1)*math.floor(string.len(i)/word_divider))
          l = l+1
        else
          list_of_words[l] = string.sub(i,1+(x-1)*math.floor(string.len(i)/word_divider), x*math.floor(string.len(i)/word_divider))
          l = l+1
        end
      end
    else
      list_of_words[l] = i
      l = l+1
    end
  end
  return list_of_words, l-1
end