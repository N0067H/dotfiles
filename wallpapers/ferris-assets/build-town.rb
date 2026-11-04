require 'base64'

root = File.expand_path('..', __dir__)
rng = Random.new(17)
parts = ['<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="3840" height="2160" viewBox="0 0 1920 1080">']
parts << '<rect width="1920" height="1080" fill="#303B46"/>'
def rect(p, x, y, w, h, c, r=0)
  p << %(<rect x="#{x}" y="#{y}" width="#{w}" height="#{h}" rx="#{r}" fill="#{c}"/>)
end
def circle(p, x, y, r, c)
  p << %(<circle cx="#{x}" cy="#{y}" r="#{r}" fill="#{c}"/>)
end
# A quiet network of broad pedestrian lanes, with no lighting or dimensional effects.
[240,490,740,990].each { |y| rect(parts,0,y,1920,58,'#414C56',29) }
[250,778,1306,1834].each { |x| rect(parts,x,120,40,930,'#414C56',20) }
palettes = [['#889F9A','#586F72'],['#B6AB93','#827667'],['#AE8E82','#795D5C'],['#9096AA','#636B84'],['#A3AC92','#6C7D72']]
4.times do |row|
  7.times do |col|
    x = 56 + col*264 + rng.rand(-12..12)
    y = 104 + row*250 + rng.rand(-8..8)
    w = rng.rand(120..162)
    h = rng.rand(93..116)
    wall, roof = palettes[(row*3+col)%palettes.size]
    rect(parts,x,y,w,h,wall,5)
    if (row+col)%3 == 0
      parts << %(<path d="M #{x-9} #{y+4} L #{x+w/2} #{y-39} L #{x+w+9} #{y+4} Z" fill="#{roof}"/>)
    else
      rect(parts,x-7,y-13,w+14,24,roof,4)
    end
    rect(parts,x+w/2-12,y+h-36,24,36,'#43525B',3)
    [x+20,x+w-41].each do |wx|
      rect(parts,wx,y+24,22,25,'#D1C3A2',3)
      rect(parts,wx+10,y+24,2,25,roof)
    end
    if (col+row)%4 == 1
      rect(parts,x-3,y+h-53,w+6,15,'#D0B599',2)
      6.times { |i| rect(parts,x+i*(w+6)/6.0-3,y+h-53,(w+6)/12.0,15,'#967B78',1) }
    end
    # Tiny flat trees and flower planters give the town a lived-in rhythm.
    tx=x+w+29
    rect(parts,tx-3,y+h-29,6,27,'#8D8776',2)
    circle(parts,tx,y+h-41,18,'#627F79')
    circle(parts,tx-9,y+h-44,12,'#718D80')
    rect(parts,x+7,y+h+7,37,8,'#7F6B65',3)
    3.times { |i| circle(parts,x+14+i*11,y+h+4,4,['#BC939B','#C4AE88','#9DAE97'][i]) }
  end
end
# Actual original Ferris illustrations, embedded without redrawing the character.
assets = %w[ferris-flat ferris-happy ferris-cuddly-transparent].map do |name|
  'data:image/png;base64,' + Base64.strict_encode64(File.binread(File.join(__dir__,name+'.png')))
end
4.times do |row|
  y=239+row*250
  8.times do |i|
    x=65+i*235+rng.rand(-35..35)
    width=rng.rand(36..52)
    height=width*0.72
    parts << %(<image x="#{x}" y="#{y+rng.rand(-3..15)}" width="#{width}" height="#{height}" xlink:href="#{assets[(i+row)%3]}"/>)
  end
end
# A few neighbors chatting by the paths between blocks.
[250,778,1306,1834].each_with_index do |x,j|
  1.times do |i|
    parts << %(<image x="#{x+4}" y="#{338+(j%3)*250}" width="38" height="28" xlink:href="#{assets[(i+j)%3]}"/>)
  end
end
parts << '</svg>'
File.write(File.join(root,'ferris-town.svg'),parts.join("\n"))
