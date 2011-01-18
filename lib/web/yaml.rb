require 'yaml'

class FetchError < StandardError; end
class SharedAlreadyError < StandardError; end

module HH::YAML
  def http(meth, path, params = nil, &blk)
    url = HH::REST + path.to_s
    body, headers = nil, {'Accept' => 'text/yaml'}
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
    HH::APP.download url, :method => meth, :body => body, :headers => headers do |dl|
      blk[dl] if blk
    end
  end

  def escape(string)
    string.to_s.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
      '%' + $1.unpack('H2' * $1.size).join('%').upcase
    end.tr(' ', '+')
  end

  def qs(hsh, prefix = [])
    hsh.map do |k, v|
      ary = prefix + [k]
      case v
      when Hash
        qs(v, ary)
      else
        ok = escape(ary.first) +
          ary[1..-1].map { |x| "[#{escape(x)}]" }.join
        "#{ok}=#{escape(v)}"
      end
    end.join("&")
  end
end

