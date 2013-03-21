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
        @attr.nil? ? nil : @attr.cont
      end
      def sexp_mismatch(type)
        STDERR.puts("Warning: #{type} SEXP size mismatch")
      end
      def initialize(*args)
        @attr=nil
        if args.size==0

        elsif
          r=args[0]
          r=Rserve::REXP::Null if r.nil?
          a=r.attr
          @cont=r
          @attr=REXPFactory.new(a) if !a.nil?
          if r.is_a? REXP::Null
            @type=XT_NULL
          elsif r.is_a? REXP::List
            l=r.as_list
            @type=l.named? ? XT_LIST_TAG : XT_LIST_NOTAG
            if r.is_a? REXP::Language
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
            @type = XT_ARRAY_STR
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
        
        puts "content:#{buf.slice(o,xl+4)} '#{buf.slice(o+4,xl+4).pack("C*")}'" if $DEBUG
        
        is_long = (buf[o]&64 )!=0
        xt = buf[o]&63
        o+=4 if is_long
        o+=4
        eox=o+xl
        @type=xt

        @attr=REXPFactory.new()
        @cont=nil
        if has_at
          puts "Processing attribs:" if $DEBUG
          o = attr.parse_REXP(buf, o)
          puts "FINAL ATTRIB:" if $DEBUG
          pp get_attr.as_list if $DEBUG
        end
        puts "REXP: #{xt_name(@type)}(#{@type})[#{o},#{xl}], attr?:#{has_at}, attr=[#{get_attr}]" if $DEBUG



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
          b[0]=REXP::Logical::NA if (b[0]!=0 && b[0]!=1)
          @cont=REXP::Logical.new(b,get_attr)
          o+=1
          if(o!=eox)
            sexp_mismatch("Warning: bool SEXP size mismatch\n") if (eox!=o+3) # o+3 could happen if the result was aligned (1 byte data + 3 bytes padding)
            o=eox
          end
          return o
        end
        if xt==XT_ARRAY_BOOL_UA
          as=(eox-o)
          i=0
          d=Array.new(as)
          (eox-i).times {|ii| d[ii]=buf[o+ii]}
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
          as.times {|ai| d[ai]=buf[o+ai]}
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
            ca = get_attr().as_list["class"]
            ls = get_attr().as_list["levels"]
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

        if (xt==XT_RAW)
          as=get_int(buf,o);
          o+=4
          d=buf[o,as]
          o = eox;
          @cont = REXP::Raw.new(d, get_attr);
          return o;
        end

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
            puts "Adding '#{name}'='#{lc.cont.inspect}'" if $DEBUG
            if name.nil?
              l.push(lc.cont)
            else
              l.put(name,lc.cont)
            end
          end
          p l.inspect if $DEBUG

          @cont=(xt==XT_LANG_NOTAG or xt==XT_LANG_TAG) ?
          REXP::Language.new(l, get_attr) : REXP::List.new(l, get_attr)
          pp @cont if $DEBUG
          if(o!=eox)
            $STDERR.puts "Mismatch"
            o=eox
          end

          return o

        end


        # old-style lists, for comaptibility with older Rserve versions - rather inefficient since we have to convert the recusively stored structures into a flat structure
        # NOT TESTED YET
        if (xt==XT_LIST or xt==XT_LANG)  #
          is_root= false
          if (root_list.nil?)
            root_list = Rlist.new();
            is_root= true;
          end
          headf = REXPFactory.new();
          tagf = REXPFactory.new();
          o = headf.parse_REXP(buf, o);
          el_index = root_list.size();
          root_list.add(headf.cont);
          #System.out.println("HEAD="+headf.cont);
          o = parse_REXP(buf, o); # we use ourselves recursively for the body
          if (o < eox)
            o = tagf.parseREXP(buf, o);
            #//System.out.println("TAG="+tagf.cont);
            if (!tagf.cont.nil? and (tagf.cont.string? or tagf.cont.symbol?))

              root_list.set_key_at(el_index, tagf.cont.as_string);
            end
          end
          if (is_root)
            @cont = (xt==XT_LIST)?
            REXP::List.new(root_list, get_attr):
            REXP::Language.new(root_list, get_attr)
            root_list = nil;
            #System.out.println("result="+cont);
          end
          return o;
        end




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
            puts "PROCESSING NAMES" if $DEBUG
            nam=get_attr.as_list['names']
            names=nil
            if nam.string?
              names=nam.as_strings
            elsif nam.vector?
              names=nam.as_list.map {|vv| vv.as_string}
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
            xx=REXPFactory.new
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
          while (buf[i]!=0 && i<eox)
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

        if (xt==XT_SYM)
          sym = REXPFactory.new
          o = sym.parse_REXP(buf, o); # PRINTNAME that's all we will use
          @cont = REXP::Symbol.new(sym.get__REXP().as_string) # content of a symbol is its printname string (so far)
          o=eox;
          return o;
        end

        if (xt==XT_CLOS)
          headf = REXPFactory.new()
          bodyf = REXPFactory.new()
          o=headf.parse_REXP(buf,o)
          o=bodyf.parse_REXP(buf,o)
          @cont=REXP::Function.new(headf.cont,bodyf.cont)
          if o!=eox
            $STDERR.puts "CLOS SEXP size mismatch"
            o=eox
          end
          return o;
        end

        if (xt==XT_UNKNOWN)
          @cont = REXP::Unknown.new(get_int(buf,o), get_attr)
          o=eox;
          return o;
        end

        if (xt==XT_S4)
          @cont = REXP::S4.new(get_attr)
          o=eox
          return o;
        end
        @cont=nil
        o=eox
        raise "Unhandled type:#{xt}"
        return o
      end # def



      # Calculates the length of the binary representation of the REXP including all headers.
      # This is the amount of memory necessary to store the REXP via do@link #getBinaryRepresentationend.
      # Please note that currently only XT_[ARRAY_]INT, XT_[ARRAY_]DOUBLE and XT_[ARRAY_]STR are supported! All other types will return 4
      # which is the size of the header.
      # @return length of the REXP including headers (4 or 8 bytes)*/
      def get_binary_length
        l=0
        rxt = type
        if (type==XT_LIST or type==XT_LIST_TAG or type==XT_LIST_NOTAG)
          rxt=(!cont.as_list.nil? and cont.as_list.named?) ? XT_LIST_TAG : XT_LIST_NOTAG;
        end
        #System.out.print("len["+xtName(type)+"/"+xtName(rxt)+"] ");
        rxt=XT_ARRAY_STR if (type==XT_VECTOR_STR) ; # VECTOR_STR is broken right now


        has_attr= false;
        a = get_attr;
        al = nil;
        al = a.as_list if (!a.nil?)
        has_attr=true if (!al.nil? and al.size()>0)
        l+=attr.get_binary_length if has_attr

        if (rxt==XT_NULL or rxt==XT_S4)
        elsif (rxt==XT_INT)
          l+=4
        elsif (rxt==XT_DOUBLE)
          l+=8
        elsif (rxt==XT_RAW)
          l+=4 + cont.as_bytes.length
          l=l-(l&3)+4 if ((l&3)>0)
        elsif (rxt==XT_STR or rxt==XT_SYMNAME)
          l+=(cont.nil?)?1:(cont.as_string.length()+1);
          l=l-(l&3)+4 if ((l&3)>0)
        elsif (rxt==XT_ARRAY_INT)
          l+=cont.as_integers().length*4
        elsif (rxt==XT_ARRAY_DOUBLE)
          l+=cont.as_doubles().length*8
        elsif (rxt==XT_ARRAY_CPLX)
          l+=cont.as_doubles().length*8
        elsif (rxt==XT_ARRAY_BOOL)
          l += cont.as_bytes().length + 4
          l = l - (l & 3) + 4 if ((l & 3) > 0)
        elsif ([XT_LIST_TAG, XT_LIST_NOTAG, XT_LANG_TAG, XT_LANG_NOTAG, XT_LIST, XT_VECTOR].include? rxt)
          lst = cont.as_list
          i=0
          while (i<lst.size)
            x=lst.at(i)
            l+=(x.nil?)?4:(REXPFactory.new(x).get_binary_length)
            if(rxt==XT_LIST_TAG)
              pl=l
              s=lst.key_at(i)
              l+=4
              l+=(s.nil?) ? 1:(s.length+1)
              l=l-(l&3)+4 if ((l&3)>0)
            end
            i+=1
          end
          l=l-(l&3)+4 if ((l&3)>0)
        elsif rxt==XT_ARRAY_STR
          sa=cont.as_strings
          i=0
          sa.each do |v|
            if(!v.nil?)
              b=v.unpack("C*")
              l+=b.length
            end
            l+=1
          end

          l=l-(l&3)+4 if ((l&3)>0)
        else
          raise "NOT IMPLEMENTED"
        end
        l+=4 if (l>0xfffff0)
        l+4
      end
      
      
      
      def get_binary_representation(buf,off)
        myl=get_binary_length;
        is_large=(myl>0xfffff0);
        a = get_attr;
        al = nil;
        al = a.as_list if (!a.nil?)
        has_attr=(!al.nil? and al.size()>0)
        rxt=type
        ooff=off
        rxt==XT_ARRAY_STR if(type==XT_VECTOR_STR) #  VECTOR_STR is broken right now
        if (type==XT_LIST || type==XT_LIST_TAG || type==XT_LIST_NOTAG)
          rxt=(!cont.as_list.nil? and cont.as_list.named?) ? XT_LIST_TAG : XT_LIST_NOTAG
        end
        set_hdr(rxt|(has_attr ? XT_HAS_ATTR : 0), myl - (is_large ? 8 : 4 ),buf,off);
        off+=(is_large ? 8 : 4);
        if has_attr
          puts "REXP BIN ATTR: #{attr.cont.inspect}" if $DEBUG
          off=attr.get_binary_representation(buf, off)
        end


        puts "REXP BIN: #{xt_name(rxt)}(#{rxt})[#{myl}], '#{cont.inspect}' attr?:#{has_attr}" if $DEBUG



        if(rxt==XT_S4 or rxt==XT_NULL)
        elsif(rxt==XT_INT)
          set_int(cont.as_integer, buf, off)
        elsif(rxt==XT_DOUBLE)

          set_long(doubleToRawLongBits(cont.as_double), buf, off)
        elsif(rxt==XT_ARRAY_INT)
          ia=cont.as_integers
          io=off
          ia.each{|v| set_int(v,buf,io); io+=4}
        elsif(rxt==XT_ARRAY_BOOL)
          ba=cont.as_bytes
          io=off
          set_int(ba.length,buf,io)
          io+=4
          if(ba.length>0)
            ba.each {|v|
              buf[io] = ( (v == REXP::Logical::NA) ? 2 : ((v == REXP::Logical::FALSE) ? 0 : 1) );
              io+=1
            }
            while ((io & 3) != 0)
              buf[io] = 3
              io+=1
            end
          end

        elsif(rxt==XT_ARRAY_DOUBLE)
          da=cont.payload
          io=off
          da.each do |v|
            # HACK
            # On i686, NA returns [162, 7, 0, 0, 0, 0, 240, 127]
            # So if we got a Double::NA, we should set mannualy this array
            if cont.na? v
            #if v==REXP::Double::NA
              buf[io,8]=REXP::Double::NA_ARRAY
            else
              set_long(doubleToRawLongBits(v), buf, io)
            end
            io+=8
          end
        elsif(rxt==XT_RAW)
          by=cont.as_bytes
          set_int(by.length,buf,off);
          off+=4
          by.each_with_index {|v,i| buf[off+i]=v}
		  off+=by.length
		  while ((off & 3) != 0)
            buf[off] = 0
            off+=1
          end
        elsif(rxt==XT_ARRAY_STR)
          sa=cont.as_strings
          io=off
          sa.each do |v|
            if !v.nil?
              b=v.unpack("C*")
              b.each_with_index{|vv,index| buf[io+index]=vv}
              io+=b.length
            end
            buf[io]=0
            io+=1
          end
          i=io-off
          while ((i&3)!=0)
            buf[io]=1;
            io+=1
            i+=1              # padding if necessary..
          end

        elsif ([XT_LIST_TAG, XT_LIST_NOTAG, XT_LANG_TAG, XT_LANG_NOTAG, XT_LIST, XT_VECTOR,XT_VECTOR_EXP].include? rxt)
          io=off
          #puts "io:#{io}"
          lst=cont.as_list
          #p lst
          if !lst.nil?
            lst.size.times do |ii|
              x=lst.at(ii)
              #puts "#{x}"
              x==REXP::Null if x.nil?
              #p buf
              io=REXPFactory.new(x).get_binary_representation(buf,io)
              #p buf
              #p io
              if(rxt==XT_LIST_TAG or rxt==XT_LANG_TAG)
                
                io=REXPFactory.new(REXP::Symbol.new(lst.key_at(ii))).get_binary_representation(buf, io)

              end
            end #times
          end #end if

        elsif (rxt==XT_SYMNAME or rxt==XT_STR)
          get_string_binary_representation(buf,off,cont.as_string)
        else
          raise "Can't represent on binary #{xt_name{rxt}}"
        end

        # end def
        puts "END BUFFER:#{buf}" if $DEBUG
        ooff+myl
      end
      def get_string_binary_representation(buf,off,s)
        s||=""
        io=off
        b=s.unpack("C*")
        puts "STRING REPRESENTATION: #{b}" if $DEBUG
        b.each_with_index {|v,i| buf[io+i]=v}
        io+=b.length
        buf[io]=0
        io+=1
        while ((io&3)!=0)
          buf[io]=0; # padding if necessary..
          io+=1
        end
        io
      end
      def xt_name(xt)
        case xt
        when XT_NULL then  "NULL";
        when XT_INT then  "INT";
        when XT_STR then  "STRING";
        when XT_DOUBLE then  "REAL";
        when XT_BOOL then  "BOOL";
        when XT_ARRAY_INT then  "INT*";
        when XT_ARRAY_STR then  "STRING*";
        when XT_ARRAY_DOUBLE then  "REAL*";
        when XT_ARRAY_BOOL then  "BOOL*";
        when XT_ARRAY_CPLX then  "COMPLEX*";
        when XT_SYM then  "SYMBOL";
        when XT_SYMNAME then  "SYMNAME";
        when XT_LANG then  "LANG";
        when XT_LIST then  "LIST";
        when XT_LIST_TAG then  "LIST+T";
        when XT_LIST_NOTAG then  "LIST/T";
        when XT_LANG_TAG then  "LANG+T";
        when XT_LANG_NOTAG then  "LANG/T";
        when XT_CLOS then  "CLOS";
        when XT_RAW then  "RAW";
        when XT_S4 then  "S4";
        when XT_VECTOR then  "VECTOR";
        when XT_VECTOR_STR then  "STRING[]";
        when XT_VECTOR_EXP then  "EXPR[]";
        when XT_FACTOR then  "FACTOR";
        when XT_UNKNOWN then  "UNKNOWN";
        else
          "<unknown #{xt}"
        end
      end





    end # Factory
  end # end Protocol
end # end Rserve
