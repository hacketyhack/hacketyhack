#
# = Address =
# map a real street address
#
def address(str)
  Address.new(str)
end

class Address < String
  APPID = "YD-bGrhXEw_JXyniyYzf1l6_NzPNWbPu6Ey5Q--"
  YAHOO = "http://api.local.yahoo.com/MapsService/V1/mapImage?appid="
  def widget(app)
    app.download(YAHOO + "&image_width=474&location=" + URI.escape(self)) do |doc|
      app.image Hpricot(doc.response.body).at("result").inner_text
    end
  end
end
