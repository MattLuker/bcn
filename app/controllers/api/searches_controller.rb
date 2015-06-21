class Api::SearchesController < Api::ApiController

  def index
    results = Search.new(query: params['query']).results
    results = results.select { |r| !r.nil? }
    results = results.sort { |a, b| b.class.to_s <=> a.class.to_s }

    render status: 200, json: {
                          message: "Found #{results.count} matches.",
                          results: results,
                      }.to_json
  end
end