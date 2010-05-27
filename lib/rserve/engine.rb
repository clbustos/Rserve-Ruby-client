module Rserve
  class Engine
    def parse(text,resolve);end
    def evaluate(what, where, resolve); end;
    def assign(symbol, value, env=nil);end;
    def get(symbol, env, resolve);end;
    def resolve_reference(ref);end;
    def create_reference(value);end;
    def finalize_reference(ref);end;
    def get_parent_enviroment(env,resolve);end;
    def new_enviroment(parent,resolve);end;
    def parse_and_eval(text,where=nil,resolve=true)
      p=parse(text,false)
      evaluate(p,where,resolve)
    end
    def close;
    false
    end
    def supports_references?
    false
    end
    def supports_enviroments?
    false
    end
    def supports_REPL?
    false
    end
    def suuports_locking?
    false
    end
    def try_lock
    0
    end
    def lock
    0
    end
    def unlock;end;
  
  end
end
