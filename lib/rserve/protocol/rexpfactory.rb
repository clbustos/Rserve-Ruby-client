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
          o=attr.parse_REXP(buf,o) if has_at 
          if xt==XT_NULL
            @cont=REXP::Null(get_attr)
            return o
          end
          if xt==XT_DOUBLE
            lr=get_long(buf,o)
            d=[lr]
            o+=8
            if(o!=eox)
              $STDERR.puts("Warning: double SEXP size mismatch\n");
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
              d[i]=get_long(buf,o)
              o+=8
              i+=1
            end
            if(o!=eox)
              $STDERR.puts("Warning: double SEXP size mismatch\n");
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
              if d[j]!=0 && d[j]!=1 
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
            d.length.each {|j| 
              if d[j]!=0 && d[j]!=1 
                d[j]==REXP::Logical::NA
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
          # hack for list. Not implemented yet!
            @cont=nil
            @cont=REXP::Integer(d,get_attr)
            return o
          end
          
          # RAW not implemented yet
          if xt==XT_LIST_NOTAG or xt==XT_LIST_TAG or xt==XT_LANG_NOTAG or xt==XT_LANG_TAG
            lc=REXPFactory.new
            nf=REXPFactory.new
            l=RList.new
            while(o<eox)
              name=nil
              o=lc.parse_REXP(buf,o)
              if(xt==XT_LIST_TAG or xt==XT_LANG_TAG)
                o=nf.parse_REXP(buf,o)
                name=nf.cont.as_strings if(nf.cont.symbol? or nf.cont.string?)
              end
              if name.nil?
                l.add(lc.cont) 
              else
                l.put(name,lc.cont)
              end
            end
            @cont=(xt==XT_LANG_NOTAG or xt==XT_LANG_TAG) ? REXP::Language.new(l,get_attr) : REXP::List.new(l, get_attr)
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
              xx=new REXPFactory.new()
              o = xx.parse_REXP(buf,o);
              v.push(xx.cont);
            end
            if (o!=eox) 
              $STDERR.puts("Warning: int vector SEXP size mismatch\n");
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
              l=RList.new(v,names)
              @cont=(xt==XT_VECTOR_EXP) ? REXP::ExpressionVector.new(l,get_attr) : REXP::GenericVector.new(l,get_attr)
            else
              @cont=(xt==XT_VECTOR_EXP) ? REXP::ExpressionVector.new(RList.new(v), get_attr) : REXP::GenericVector(RList.new(v), get_attr)
              
            end
            return o
          end
          if xt==XT_ARRAY_STR
            c=0
            i=o
            while(i<eox) 
              c+=1 if buf(i)==0
              i+=1
            end
            s=Array.new(c)
            if c>0
              c=0; i=o;
              while(o < eox)
                if buf[0]==0
                  begin
                    s[c]=buf[i..(o-i)].join("")
                  rescue
                    s[c]=""
                  end
                  c+=1
                  i=o+1
                end
                o+=1
              end
              
            end
            @cont=REXP::String.new(s,get_attr)
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
          #not implemented XT_STR, XT_SYMNANE, XT_SYM, XT_CLOSS, XT_UNKNOWN, XT_S4
          @cont=nil
          o=eox
          $STDERR.puts "Unhandled type:#{xt}"
          return o
        end # def 
    end # Factory
  end # end Protocol
end # end Rserve