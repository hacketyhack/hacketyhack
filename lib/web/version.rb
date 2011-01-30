require 'lib/web/yaml'

module Upgrade
  class << self
    include HH::YAML

    def check_latest_version &blk
      http('GET', "/version.json") do |result| 
        response = JSON.parse(result.response.body)
        blk[response]
      end
    end
  end
end
