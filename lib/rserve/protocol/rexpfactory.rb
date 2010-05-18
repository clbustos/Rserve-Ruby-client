module Rserve
  module Protocol
    #  representation of R-eXpressions in Ruby
    module REXPFactory
        include Rserve::Protocol
        # xpression type: NULL 
        XT_NULL=0;
        # xpression type: integer 
        XT_INT=1;
        # xpression type: double 
        XT_DOUBLE=2;
        # xpression type: String 
        XT_STR=3;
        # xpression type: language construct (currently content is same as list) 
        XT_LANG=4;
        # xpression type: symbol (content is symbol name: String) 
        XT_SYM=5;
        # xpression type: RBool     
        XT_BOOL=6;
        # xpression type: S4 object
        #@since Rserve 0.5 
        XT_S4=7;
        # xpression type: generic vector (RList) 
        XT_VECTOR=16;
        # xpression type: dotted-pair list (RList) 
        XT_LIST=17;
        # xpression type: closure (there is no java class for that type (yet?). currently the body of the closure is stored in the content part of the REXP. Please note that this may change in the future!) 
        XT_CLOS=18;
        # xpression type: symbol name
        # @since Rserve 0.5 
        XT_SYMNAME=19;
        # xpression type: dotted-pair list (w/o tags)
        # @since Rserve 0.5 
        XT_LIST_NOTAG=20;
        # xpression type: dotted-pair list (w tags)
        # @since Rserve 0.5 
        XT_LIST_TAG=21;
        # xpression type: language list (w/o tags)
        # @since Rserve 0.5 
        XT_LANG_NOTAG=22;
        # xpression type: language list (w tags)
        # @since Rserve 0.5 
        XT_LANG_TAG=23;
        # xpression type: expression vector 
        XT_VECTOR_EXP=26;
        # xpression type: string vector 
        XT_VECTOR_STR=27;
        # xpression type: int[] 
        XT_ARRAY_INT=32;
        # xpression type: double[] 
        XT_ARRAY_DOUBLE=33;
        # xpression type: String[] (currently not used, Vector is used instead) 
        XT_ARRAY_STR=34;
        # internal use only! this constant should never appear in a REXP 
        XT_ARRAY_BOOL_UA=35;
        # xpression type: RBool[] 
        XT_ARRAY_BOOL=36;
        # xpression type: raw (byte[])
        # @since Rserve 0.4-? 
        XT_RAW=37;
        # xpression type: Complex[]
        # @since Rserve 0.5 
        XT_ARRAY_CPLX=38;
        # xpression type: unknown; no assumptions can be made about the content 
        XT_UNKNOWN=48;
        # xpression type: RFactor; this XT is internally generated (ergo is does not come from Rsrv.h) to support RFactor class which is built from XT_ARRAY_INT 
        XT_FACTOR=127; 
        # used for transport only - has attribute 
        XT_HAS_ATTR=128;
        
        attr_reader :type, :attr, :cont, :root_list
        def get_REXP
          @cont
        end
        def get_attr
          attr.nil? ? nil : attr.cont
        end
        def initialize(*args)
          if args.size==0
            
          elsif
              r=args[0]
            r=Rserve::REXP::Null if r.nil?
            a=r.attr
            @attr=Factory.new(a) if !a.nil?
            if r.is_a? REXP::Null
              @type=XT_NULL
            elsif r.is_a? REXP::List
              l=r.as_list
              @type=l.named? ? XT_LIST_TAG : XT_LIST_NOTAG
              if r.is_a? REXPLanguage
                @type = (@type==XT_LIST_TAG) ? XT_LANG_TAG : XT_LANG_NOTAG;
              end
            elsif r.is_a? REXP::GenericVector
              @type = XT_VECTOR; # FIXME: may have to adjust names attr
            elsif r.is_a? REXP::S4
              @type = XT_S4
            elsif r.is_a? REXP::Integer
              @type = XT_ARRAY_INT
            elsif r.is_a? REXP::Double
              @type = XT_ARRAY_DOUBLE
            elsif  r.is_a? REXP::String
              @type = XT_ARRAY_STRING
            elsif r.is_a? REXP::Symbol
              @type = XT_SYMNAME
            elsif r.is_a? REXP::Raw
              @type = XT_RAW
            elsif r.is_a? REXP::Logical
              @type = XT_ARRAY_BOOL
            else
              raise ArgumentError("***REXPFactory unable to interpret #{r}")
            end  
          end
        end
        def parse_REXP(buf,o)
          xl=get_len(buf,o)
          has_at  = (buf[o]&128)!=0
          is_long = (buf[o]&64 )!=0
          xt = buf[o]&63
          o+=4 if is_long
          o+=4
          eox=o+xl
          @type=xt
          @attr=Factory.new()
          @cont=nil
          o = attr.parse_REXP(get_attr)+
          Sif has_at 
        end
    end
  end
end