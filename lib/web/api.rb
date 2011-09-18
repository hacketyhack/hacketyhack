module HH::API
  @root = nil
  @refresh_time = nil

  class << self
    def root
      if !@refresh_time || (Time.now.to_i - @refresh_time.to_i) > 3600
        @refresh_time = Time.now
        @root = open("http://api.hackety-hack.com") { |f| Hpricot(f) }
      else
        @root
      end
    end
  end
end
