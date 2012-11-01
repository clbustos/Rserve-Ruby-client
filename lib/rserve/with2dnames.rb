module Rserve

  module With2DNames
    attr_reader :row_names, :column_names, :row_size, :column_size

    def sizes=(sizes)
      raise ArgumentError, "sizes must be of size 2" unless (sizes.size == 2)
      raise ArgumentError, "mismatch between provided size info and actual number of elements" unless self.size == (sizes[0] * sizes[1])
      @row_size = sizes[0]
      @column_size = sizes[1]

    end

    def names=(names)
      raise ArgumentError, "sizes must be of size 2" unless (names.size == 2)
      raise ArgumentError, "mismatch between provided size info and actual number of elements" unless ((@row_size == names[0].size) and (@column_size == names[1].size))
      @row_names = names[0]
      @column_names = names[1]
    end

    def two_d_at(i, j)
      index_i = (i.is_a? Integer) ? i : @row_names.index(i)
      index_j = (j.is_a? Integer) ? j : @column_names.index(j)
      self[index_i + index_j * row_size]
    end

    def two_d_named?
      @row_names and @column_names
    end

    def column(j)
      index_j = (j.is_a? Integer) ? j : @column_names.index(j)
    end

  end


end