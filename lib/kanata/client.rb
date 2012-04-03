# -*- coding: utf-8 -*-

require 'httpclient'
require 'xmlsimple'
require 'pp'

module Kanata
  class Client
    attr_accessor :app_id

    COMMA_SERIALIZE_KEYS = [
      :results,
      :response,
      :ma_response,
      :uniq_response,
    ].freeze

    PIPE_SERIALIZE_KEYS = [
      :filter,
      :ma_filter,
      :uniq_filter,
    ].freeze

    PARSE_DEFAULTS = {
      results: nil,
      response: [:surface, :reading, :pos, :baseform, :feature].freeze,
      ma_response: nil,
      uniq_response: nil,
      filter: nil,
      ma_filter: nil,
      uniq_filter: nil,
    }.freeze

    def initialize(app_id)
      @app_id = app_id
    end

    def http
      @http ||= HTTPClient.new
    end

    def post(path, data = {})
      url = "http://jlp.yahooapis.jp/#{path}"
      http.post(url, data)
    end

    def parse(text, options = {})
      request_options = {
        sentence: text,
        appid: @app_id,
      }.merge(options)
      {
        ',' => COMMA_SERIALIZE_KEYS,
        '|' => PIPE_SERIALIZE_KEYS,
      }.each_pair do |glue, set|
        set.each do |key|
          value = options[key] || PARSE_DEFAULTS[key]
          if value
            request_options[key] = value.join(glue)
          else
            request_options.delete key
          end
        end
      end

      begin
        response = post('MAService/V1/parse', request_options)
        xml = XmlSimple.xml_in(response.body)
        xml_words = xml["ma_result"].last["word_list"].last["word"]
        if xml_words == nil
          return []
        end
        return xml_words.map{|w|Word.new(Hash[w.map{|k,v|[k,v.last]}])}
      rescue
        raise $!
        raise "ParseError"
      end
      return nil
    end
  end
end
