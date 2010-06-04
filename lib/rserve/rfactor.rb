module Rserve
  class RFactor
    attr_reader :ids
    attr_reader :levels
    attr_reader :index_base
    def initialize(i,v,copy,index_base)
      i=[] if i.nil?
      v=[] if v.nil?
      if (copy)
        @ids=i.dup
        @levels=v.dup
      else
        @ids=i
        @levels=v
      end
      @index_base=index_base
    end
    # returns the level of a given case
    # * @param i case number
    # * @return name. may throw exception if out of range
    def [](i)
      li = @ids[i]-index_base
      return (li<0 or li>levels.length) ? nil : levels[li]
    end
    def contains?(li)
      li=level_index(li) if li.is_a? String
      @ids.any? {|v| v==li}
    end

    # return the index of a given level name or -1 if it doesn't exist
    def level_index(name)
      return nil if name.nil?
      levels.length.times {|i|
        return i+index_base if !levels[i].nil? and levels[i]==name
      }
      return nil
    end
    def count(li)
      li=level_index(li) if li.is_a? String
      @ids.inject(0) {|ac,v| ac+ ((v==li) ? 1 : 0 ) }
    end
    # return a hash with levels as keys and  counts as values
    def counts_hash
      h=@levels.inject({}) {|ac,v| ac[v]=0;ac}
      @ids.each {|v| h[@levels[v-index_base]]+=1}
      h
    end
    def as_integers
      @ids
    end
    def as_strings
      @ids.map {|v| v==REXP::Integer::NA ? nil : @levels[v-index_base]}
    end
    def index_at(i)
      @ids[i]
    end
    def size
      @ids.length
    end
    alias  :at :[]
  end
end
