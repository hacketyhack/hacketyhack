module HH::API
  @root = nil
  @refresh_time = nil

  class << self
    def root
      if !@refresh_time || (Time.now.to_i - @refresh_time.to_i) > 3600
        @refresh_time = Time.now
        @root = get('/') { |f| Hpricot(f.body) }
      else
        @root
      end
    end

    def get(path)
      url = URI.parse(HH::API_ROOT + path)
      response = Net::HTTP.get_response(url)

      yield response
    end

    def post(path, params)
      url = URI.parse(HH::API_ROOT + path)
      response = Net::HTTP.post_form(url, params)

      yield response
    end

  end

end
