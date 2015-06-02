class SearchesController < ApplicationController

  def index
    puts "params: #{params}"
    puts "params['query']: #{params['query']}"
    puts "params[:query]: #{params[:query]}"
    @results = Search.new(query: params['query']).results.sort { |a, b| b.class.to_s <=> a.class.to_s }

    #[:inspect, :to_s, :to_a, :to_h, :to_ary, :frozen?, :==, :eql?, :hash, :[], :[]=, :at, :fetch, :first, :last, :concat, :<<, :push, :pop, :shift, :unshift, :insert, :each, :each_index, :reverse_each, :length, :size, :empty?, :find_index, :index, :rindex, :join, :reverse, :reverse!, :rotate, :rotate!, :sort, :sort!, :sort_by!, :collect, :collect!, :map, :map!, :select, :select!, :keep_if, :values_at, :delete, :delete_at, :delete_if, :reject, :reject!, :zip, :transpose, :replace, :clear, :fill, :include?, :<=>, :slice, :slice!, :assoc, :rassoc, :+, :*, :-, :&, :|, :uniq, :uniq!, :compact, :compact!, :flatten, :flatten!, :count, :shuffle!, :shuffle, :sample, :cycle, :permutation, :combination, :repeated_permutation, :repeated_combination, :product, :take, :take_while, :drop, :drop_while, :bsearch, :any?, :pack, :append, :prepend, :extract_options!, :blank?, :deep_dup, :to_param, :to_query, :to_sentence, :to_formatted_s, :to_default_s, :to_xml, :to_json_with_active_support_encoder, :to_json_without_active_support_encoder, :to_json, :as_json, :from, :to, :second, :third, :fourth, :fifth, :forty_two, :shelljoin, :in_groups_of, :in_groups, :split, :to_dragonfly_unique_s, :pretty_print, :pretty_print_cycle, :columnize_opts, :columnize_opts=, :columnize, :entries, :sort_by, :grep, :find, :detect, :find_all, :flat_map, :collect_concat, :inject, :reduce, :partition, :group_by, :all?, :one?, :none?, :min, :max, :minmax, :min_by, :max_by, :minmax_by, :member?, :each_with_index, :each_entry, :each_slice, :each_cons, :each_with_object, :chunk, :slice_before, :slice_after, :slice_when, :lazy, :to_set, :sum, :index_by, :many?, :exclude?, :present?, :presence, :acts_like?, :duplicable?, :try, :try!, :in?, :presence_in, :instance_values, :instance_variable_names, :with_options, :html_safe?, :psych_to_yaml, :to_yaml, :to_yaml_properties, :`, :it, :its, :pretty_print_instance_variables, :pretty_print_inspect, :require_or_load, :require_dependency, :load_dependency, :unloadable, :nil?, :===, :=~, :!~, :class, :singleton_class, :clone, :dup, :itself, :taint, :tainted?, :untaint, :untrust, :untrusted?, :trust, :freeze, :methods, :singleton_methods, :protected_methods, :private_methods, :public_methods, :instance_variables, :instance_variable_get, :instance_variable_set, :instance_variable_defined?, :remove_instance_variable, :instance_of?, :kind_of?, :is_a?, :tap, :send, :public_send, :respond_to?, :extend, :display, :method, :public_method, :singleton_method, :define_singleton_method, :object_id, :to_enum, :enum_for, :gem, :silence_warnings, :enable_warnings, :with_warnings, :silence_stderr, :silence_stream, :suppress, :capture, :silence, :quietly, :class_eval, :pretty_inspect, :byebug, :debugger, :concern, :suppress_warnings, :equal?, :!, :!=, :instance_eval, :instance_exec, :__send__, :__id__]

  end

  # def create
  #   puts "params: #{params}"
  #   @results = Search.new(query: search_params[:query]).results
  #   puts "@results: #{@results}"
  #   #render :index, results: @results
  #   redirect_to action: 'index'
  # end

  # private
  # def search_params
  #   puts "params: #{params}"
  #   params.require(:search).permit(:query)
  # end
end