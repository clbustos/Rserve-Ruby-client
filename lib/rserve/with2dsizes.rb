module Rserve

  module With2DSizes

    attr_reader :column_size, :row_size

    def sizes=(sizes)
      raise ArgumentError, "sizes must be of size 2" unless (sizes.size == 2)
      raise ArgumentError, "mismatch between provided size info and actual number of elements" unless self.size == (sizes[0] * sizes[1])
      @row_size = sizes[0]
      @column_size = sizes[1]

    end

    def at_2d(i,j)
      self[i + j * row_size]
    end

    def row(i)
      return nil unless (-row_size...row_size) === i
      each_slice(row_size).map {|col| col[i]}
    end

    def column(j)
      return nil unless (-column_size...column_size) === j
      self[(j * row_size), row_size]
    end



  end



end