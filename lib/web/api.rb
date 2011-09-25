require 'lib/web/yaml'

module HH::API
  @root = nil
  @refresh_time = nil
  extend HH::YAML

  class << self
    def root
      if !@refresh_time || (Time.now.to_i - @refresh_time.to_i) > 3600
        @refresh_time = Time.now
        @root = open(HH::API_ROOT) { |f| Hpricot(f) }
      else
        @root
      end
    end

    def http(meth, path, params = nil, &blk)
      url = HH::API_ROOT + path.to_s
      body, headers = nil, {'Accept' => 'text/html'}
      case params
      when String
        body = params
      when Hash
        if params[:who]
          headers['X-Who'] = params.delete(:who)
        end

        if params[:post]
          body = params[:post]
        else
          x = qs(params)
          if meth == 'GET'
            url += "?" + x
          else
            body = x
            headers['Content-Type'] = 'application/x-www-form-urlencoded'
          end
        end
      end

      # if HH::PREFS['username']
      #   req.basic_auth HH::PREFS['username'], HH::PREFS['pass']
      # end
      headers['Authorization'] = 'Basic ' + ["#{HH::PREFS['username']}:#{HH::PREFS['password']}"].pack("m").strip
      HH::APP.download url, :method => meth, :body => body, :headers => headers do |dl| blk[dl] if blk
      end
    end
  end

end
