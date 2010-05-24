module Rserve
  module Protocol
    #  representation of R-eXpressions in Ruby
    class REXPFactory
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
        def sexp_mismatch(type)
          STDERR.puts("Warning: #{type} SEXP size mismatch") 
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
          #p "buffer:#{buf.to_s}"
          has_at  = (buf[o]&128)!=0
          is_long = (buf[o]&64 )!=0
          xt = buf[o]&63
          o+=4 if is_long
          o+=4
          eox=o+xl
          @type=xt
          
          @attr=REXPFactory.new()
          @cont=nil
          
          o=attr.parse_REXP(buf,o) if has_at
          
          if xt==XT_NULL
            @cont=REXP::Null.new(get_attr)
            return o
          end
          if xt==XT_DOUBLE
            lr=get_long(buf,o)
            d=[longBitsToDouble(lr)]
            o+=8
            if(o!=eox)
              sexp_mismatch("double")
              o=eox
            end
            @cont=REXP::Double.new(d,get_attr)
            return o
          end
          if xt==XT_ARRAY_DOUBLE
            as=(eox-o).quo(8)
            i=0
            d=Array.new(as)
            while(o<eox)
              d[i]=longBitsToDouble(get_long(buf,o))
              o+=8
              i+=1
            end
            if(o!=eox)
              sexp_mismatch("double")
              o=eox
            end
            @cont=REXP::Double.new(d,get_attr)
            return o
          end
          if xt==XT_BOOL
            b=[buf[o]]
            if (b[0]!=0 && b[0]!=1) 
              b[0]=REXP::Logical::NA
            end
            @cont=REXP::Logical.new(b,get_attr)
            o+=1
            return o
          end
          if xt==XT_ARRAY_BOOL_UA
            as=(eox-o)
            i=0
            d=Array.new(as)
            (eox-i).times {|i| d[i]=buf[o+i]}
            o=eox

            d.length.each {|j| 
              if d[j]!=0 and d[j]!=1
                d[j]==REXP::Logical::NA
              end
            }
            @cont=REXP::Logical.new(d,get_attr)
            return o
          end
          if xt==XT_ARRAY_BOOL
            as=get_int(buf, o)
            o+=4
            d=Array.new(as)
            as.times {|i| d[i]=buf[o+i]}
            d.collect! {|v| 
              if v!=0 and v!=1
                REXP::Logical::NA
              else
                v
              end
            }
            o=eox
            @cont=REXP::Logical.new(d,get_attr)
            return o
          end
          if xt==XT_INT
            i=Array.new(get_int(buf,o))
            @cont=REXP::Integer.new(i,get_attr)
            o+=4
            if o!=eox
              $STDERR.puts "int SEXP size mismatch"
              o=eox
            end
            return o
          end
          
          if xt==XT_ARRAY_INT
            as=(eox-o).quo(4)
            i=0
            d=Array.new(as)
            while(o<eox)
              d[i]=get_int(buf,o)
              o+=4
              i+=1
            end
            if o!=eox
              $STDERR.puts "int SEXP size mismatch"
              o=eox
            end
            
            # hack for factors
              if (!get_attr.nil?)
                ca = get_attr().as_list().at("class");
                ls = get_attr().as_list().at("levels");
                if (!ca.nil? and !ls.nil? and  ca.as_string=="factor") 
                  # R uses 1-based index, Java (and Ruby) uses 0-based one
                  @cont = REXP::Factor.new(d, ls.as_strings(), get_attr)
                  xt = XT_FACTOR;
                end
              end
            
            
            
              if @cont.nil?
                @cont=REXP::Integer.new(d,get_attr)
              end
            return o
          end
          
          # RAW not implemented yet
          
          
          if xt==XT_LIST_NOTAG or xt==XT_LIST_TAG or xt==XT_LANG_NOTAG or xt==XT_LANG_TAG
            lc=REXPFactory.new
            nf=REXPFactory.new
            l=Rlist.new
            while(o<eox)
              name=nil
              o=lc.parse_REXP(buf,o)
              if(xt==XT_LIST_TAG or xt==XT_LANG_TAG)
                o=nf.parse_REXP(buf,o)
                
                name=nf.cont.as_string if(nf.cont.symbol? or nf.cont.string?)
              end
              if name.nil?
                
                l.add(lc.cont) 
              else
                l.put(name,lc.cont)
              end
            end
            
            @cont=(xt==XT_LANG_NOTAG or xt==XT_LANG_TAG) ? 
            REXP::Language.new(l,get_attr) : REXP::List.new(l, get_attr)
            
            if(o!=eox)
              $STDERR.puts "Mismatch"
              o=eox
            end
            
            return o
          
          end
          
          
          # XT_LIST and XT_LANG not implemented yet
          
          if xt==XT_VECTOR or xt==XT_VECTOR_EXP
            v=Array.new
            while(o<eox)
              xx=REXPFactory.new()
              o = xx.parse_REXP(buf,o);
              v.push(xx.cont);
            end
            if (o!=eox) 
              sexp_mismatch("int")
              o=eox;
            end
            # fixup for lists since they're stored as attributes of vectors
            if !get_attr.nil? and !get_attr.as_list['names'].nil?
              nam=get_attr.as_list['names']
              names=nil
              if nam.string?
                names=nam.as_strings 
              elsif nam.vector?
                l=nam.to_a
                names=Array.new(aa.length)
                aa.length.times {|i| names[i]=aa[i].as_string}
              end
              l=Rlist.new(v,names)
              @cont=(xt==XT_VECTOR_EXP) ? REXP::ExpressionVector.new(l,get_attr) : REXP::GenericVector.new(l,get_attr)
            else
              
              @cont=(xt==XT_VECTOR_EXP) ? REXP::ExpressionVector.new(Rlist.new(v), get_attr) : REXP::GenericVector.new(Rlist.new(v), get_attr)
            end
            return o
          end
          if xt==XT_ARRAY_STR
            c=0
            i=o
            while(i<eox) 
              c+=1 if buf[i]==0
              i+=1
            end
            s=Array.new(c)
            if c>0
              c=0; i=o;
              while(o < eox)
                if buf[o]==0
                  begin
                    s[c]=buf[i,o-i].pack("C*")
                  rescue
                    s[c]=""
                  end
                  c+=1
                  i=o+1
                end
                o+=1
              end
              
            end
            @cont=REXP::String.new(s, get_attr)
            return o
          end
          if xt==XT_VECTOR_STR
            v=Array.new
            while(o<eox)
              xx=REXP::Factory.new
              o=xx.parse_REXP(buf,o)
              v.push(xx.cont.as_string)
            end
            sa=Array.new(v.size)
            i=0
            while(i<sa.length)
              sa[i]=v.get(i)
              i+=1
            end
            @cont=REXP::String.new(sa,get_attr)
            return o
          end
          
     if (xt==XT_STR||xt==XT_SYMNAME) 
			i = o;
			while (buf[i]!=0 && i<eox) do
        i+=1
      end
				if (xt==XT_STR)
					@cont = REXP::String.new(buf[o,i-o].pack("C*"), get_attr);
          
				else
					@cont = REXP::Symbol.new(buf[o,i-o].pack("C*"))
        end
      
			o = eox;
			return o;
    end
    
    #not implemented  XT_SYM, 
    
    
    if (xt==XT_CLOS) 
			o=eox;
			return o;
    end
		
		if (xt==XT_UNKNOWN) 
			@cont = REXP::Unknown.new(get_int(buf,o), get_attr)
			o=eox;
			return o;
    end
		
		if (xt==XT_S4) 
			@cont = new REXP::S4(get_attr)
			o=eox
			return o;
    end
          
          @cont=nil
          o=eox
          raise "Unhandled type:#{xt}"
          return o
        end # def 
    end # Factory
  end # end Protocol
end # end Rserve