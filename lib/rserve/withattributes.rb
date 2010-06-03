module Rserve
  module WithAttributes
    attr_accessor :attributes
    def has_attribute?(v)
      !@attributes.nil? and !attributes[v].nil?
    end
  end
end
