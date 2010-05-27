require 'forwardable'
module Rserve
  class REXP
    class Reference < REXP
      extend Forwardable
      attr_reader :eng
      attr_reader :handle
      attr_reader :resolved_value

      def initialize(e,h)
        super()
        @eng=e
        @handle=h
        @resolved_value=nil
      end

      # check type methods
      def_delegators :@resolved_value, :string?, :numeric?, :integer?, :null?, :factor?, :list?, :logical?, :environment? , :language?, :symbol?, :vector?, :raw?, :complex?, :recursive?
      # convertion methods
      def_delegators :@resolved_value, :as_strings, :as_integers, :as_floats, :as_list, :as_factor
      # other methods
      def_delegators :@resolved_value, :attr, :length

      def reference?
        true
      end
      def resolve
        @resolved_value||= @eng.resolve_reference(self)
      end
      def invalidate
        @resolved_value=nil
      end
      def finalize
        begin
          @eng.finalize_reference(self)
        ensure
          super.finalize()
        end
      end
    end
  end
end
