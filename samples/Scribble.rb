Shoes.app do
  ox, oy = nil, nil
  animate 24 do
    b, x, y = self.mouse
    line(ox, oy, x, y)  if b == 1
    ox, oy = x, y
  end
end

