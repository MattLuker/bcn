class SearchesController < ApplicationController

  def index
    @results = Search.new(query: params['query']).results
    @results = @results.select { |r| !r.nil? }
    @results = @results.sort { |a, b| b.class.to_s <=> a.class.to_s }
  end
end