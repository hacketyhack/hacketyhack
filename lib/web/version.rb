require 'lib/web/yaml'
require 'lib/web/api'

module Upgrade
  class << self
    include HH::YAML

    def check_latest_version &blk
      version_rel = HH::API.root.at("//a[@rel='/rels/current-application-version']")
      http('GET', version_rel.attributes['href']) do |result|
        response = JSON.parse(result.response.body)
        blk[response]
      end
    end
  end
end
