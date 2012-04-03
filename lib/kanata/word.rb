# -*- coding: utf-8 -*-

module Kanata
  class Word
    attr_reader :surface, :reading, :pos, :baseform, :feature
    def initialize(hash)
      @surface  = hash["surface"]
      @reading  = hash["reading"]
      @pos      = hash["pos"]
      @baseform = hash["baseform"]
      @feature  = hash["feature"]
    end
  end
end
