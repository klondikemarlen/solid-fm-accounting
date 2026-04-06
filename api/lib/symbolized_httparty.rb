require "httparty"
require "json"

class SymbolizedHTTParty
  include HTTParty

  class Parser < HTTParty::Parser
    def json
      JSON.parse(body, symbolize_names: true)
    end
  end

  parser Parser
end
