require 'base64'
root = File.expand_path('../wallpapers/archive/ferris', __dir__)
asset_dir = File.expand_path('../wallpapers/sources/ferris', __dir__)
p = ['<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="3840" height="2160" viewBox="0 0 1920 1080">', '<rect width="1920" height="1080" fill="#303B46"/>']
def rect(p,x,y,w,h,c,r=0)
  p << %(<rect x="#{x}" y="#{y}" width="#{w}" height="#{h}" rx="#{r}" fill="#{c}"/>)
end
def circle(p,x,y,r,c)
  p << %(<circle cx="#{x}" cy="#{y}" r="#{r}" fill="#{c}"/>)
end
colors = [['#7E9390','#53696D'],['#A49B88','#776E61'],['#9D837B','#705B5B'],['#858C9F','#5D657D']]
def house(p,x,y,w,h,colors,index)
  wall,roof=colors[index%colors.size]
  rect(p,x,y,w,h,wall,4)
  if index.even?
    p << %(<path d="M#{x-5},#{y+2} L#{x+w/2},#{y-23} L#{x+w+5},#{y+2}Z" fill="#{roof}"/>)
  else
    rect(p,x-4,y-8,w+8,15,roof,3)
  end
  rect(p,x+w/2-8,y+h-25,16,25,'#43515A',2)
  [x+12,x+w-27].each { |wx| rect(p,wx,y+19,15,18,'#B9B194',2) }
  tx=x+w+17
  rect(p,tx-2,y+h-17,4,17,'#807B6E',1)
  circle(p,tx,y+h-27,12,'#627D76')
end
rect(p,0,1024,1920,38,'#3D4953',15)
[0,1800].each { |x| rect(p,x+10,190,110,848,'#36434D',18) }
11.times do |i|
  x=26+i*172
  house(p,x,927+(i%3)*9,99+(i%2)*12,84-(i%3)*9,colors,i)
end
[22,1807].each_with_index do |x,side|
  [260,510,760].each_with_index { |y,i| house(p,x,y,81,77,colors,i+side) }
end
assets=%w[ferris-flat ferris-happy ferris-cuddly-transparent].map { |n| 'data:image/png;base64,'+Base64.strict_encode64(File.binread(File.join(asset_dir,n+'.png'))) }
11.times do |i|
  p << %(<image x="#{64+i*172}" y="1026" width="35" height="25" xlink:href="#{assets[i%3]}"/>)
end
[30,1823].each_with_index do |x,side|
  [365,615,865].each_with_index do |y,i|
    p << %(<image x="#{x}" y="#{y}" width="35" height="25" xlink:href="#{assets[(i+side)%3]}"/>)
  end
end
p << '</svg>'
File.write(File.join(root,'ferris-town-quiet.svg'),p.join("\n"))
