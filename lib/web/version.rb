require 'lib/web/api'
require 'net/http'

module Upgrade
  class << self
    include HH::API

    def check_latest_version &blk
      version_rel = HH::API.root.at("//a[@rel='/rels/current-application-version']")
      HH::API.get(version_rel.attributes['href']) do |response|
        body = JSON.parse(response.body)
        blk[body]
      end
    end
  end
end
