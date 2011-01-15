module Rserve
  class REXP
    # REXPEnvironment represents an environment in R. Very much like {@link org.rosuda.REngine.REXPReference} this is a proxy object to the actual object on the R side. It provides methods for accessing the content of the environment. The actual implementation may vary by the back-end used and not all engines support environments. Check {@link org.rosuda.REngine.REngine.supportsEnvironments()} for the given engine. Environments are specific for a given engine, they cannot be passed across engines
    class Environment < REXP
      attr_reader :eng
      attr_reader :handle
      # create a new environemnt reference - this constructor should never be used directly, use {@link REngine.newEnvironment()} instead.
      # * @param eng engine responsible for this environment
      # * @param handle handle used by the engine to identify this environment
      def initialize(e,h)
        super()
        @eng = e
        @handle = h
      end
      def environment?
        true
      end

      # get a value from this environment
      # * @param name name of the value
      # * @param resolve if <code>false</code> returns a reference to the object, if <code>false</code> the reference is resolved
      # * @return value corresponding to the symbol name or possibly <code>null</code> if the value is unbound (the latter is currently engine-specific)
      def get(name, resolve=true)
        @eng.get(name,self,resolve)
      end
      # assigns a value to a given symbol name
      #  @param name symbol name
      #  @param value value */
      def assign(name, value)
        @eng.assign(name, value, self)
      end
      def parent(resolve=true)
        @eng.get_parent_environment(self,resolve)
      end
    end
  end
end
