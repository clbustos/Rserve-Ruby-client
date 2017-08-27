require 'rbconfig'
module Rserve
  #
  # This module encapsulates methods and constants related to QAP1 protocol used by Rserv. Follows almost exactly the interface on RTalk class
  # on Java version, except for use of undescores instead of CamelCase
  # Implementation could differ if a cleaner/faster ruby version is available
  #
  # Policy: No other class should know about the internal of protocol!
  # See Rtalk class on Java version.
  module Protocol
    # Arch dependent Long Nil value 
    case RbConfig::CONFIG['arch']
      when /i686-linux|mswin|mingw/
        LONG_NA=9221120237041092514 # :nodoc:
      else
        LONG_NA=9218868437227407266 # :nodoc:
    end
    # Defines from Rsrv.h
    CMD_RESP=0x010000 # all responses have this flag set
    RESP_OK=(CMD_RESP|0x0001) # command succeeded; returned parameters depend on the command issued
    RESP_ERR=(CMD_RESP|0x0002) # command failed, check stats code attached string may describe the error
    ERR_auth_failed=0x41 # auth.failed or auth.requested but no login came. in case of authentification failure due to name/pwd mismatch, server may send CMD_accessDenied instead
    ERR_conn_broken=0x42 #  connection closed or broken packet killed it */

    ERR_inv_cmd=0x43 #  unsupported/invalid command */
    ERR_inv_par=0x44 #  some parameters are invalid */
    ERR_Rerror=0x45 #  R-error occured, usually followed by connection shutdown */
    ERR_IOerror=0x46 #  I/O error */


    ERR_notOpen=0x47 #  attempt to perform fileRead/Write  on closed file */
    ERR_accessDenied=0x48 #  this answer is also valid on CMD_login; otherwise it's sent if the server deosn;t allow the user to issue the specified command. (e.g. some server admins may block file I/O operations for some users)
    ERR_unsupportedCmd=0x49 #  unsupported command */
    ERR_unknownCmd=0x4a #  unknown command - the difference between unsupported and unknown is that unsupported commands are known to the server but for some reasons (e.g. platform dependent) it's not supported. unknown commands are simply not recognized by the server at all. */
    ERR_data_overflow=0x4b #  incoming packet is too big. currently there is a limit as of the size of an incoming packet. */
    ERR_object_too_big=0x4c #  the requested object is too big to be transported in that way. If received after CMD_eval then the evaluation itself was successful. optional parameter is the size of the object
    ERR_out_of_mem=0x4d #  out of memory. the connection is usually closed after this error was sent
    ERR_ctrl_closed=0x4e #  control pipe to the master process is closed or broken
    ERR_session_busy=0x50 #  session is still busy */
    ERR_detach_failed=0x51 #  unable to detach session (cannot determine peer IP or problems creating a listening socket for resume) */


    CMD_login=0x001 #  "name\npwd" : - */
    CMD_voidEval=0x002 #  string : - */
    CMD_eval=0x003 #  string : encoded SEXP */
    CMD_shutdown=0x004 #  [admin-pwd] : - */

    #/* file I/O routines. server may answe */
    CMD_openFile=0x010 #  fn : - */
    CMD_createFile=0x011 #  fn : - */
    CMD_closeFile=0x012 #  - : - */
    CMD_readFile=0x013 #  [int size] : data... ; if size not present,
    #server is free to choose any value - usually
    #it uses the size of its static buffer */
    CMD_writeFile=0x014 #  data : - */
    CMD_removeFile=0x015 #  fn : - */

    # /* object manipulation */
    CMD_setSEXP=0x020 #  string(name), REXP : - */
    CMD_assignSEXP=0x021 #  string(name), REXP : - ; same as setSEXP except that the name is parsed */

    # /* session management (since 0.4-0) */
    CMD_detachSession=0x030 #  : session key */
    CMD_detachedVoidEval=0x031 #  string : session key; doesn't */
    CMD_attachSession=0x032 #  session key : - */

    # control commands (since 0.6-0) - passed on to the master process */
    # Note: currently all control commands are asychronous, i.e. RESP_OK
    # indicates that the command was enqueued in the master pipe, but there
    # is no guarantee that it will be processed. Moreover non-forked
    # connections (e.g. the default debug setup) don't process any
    # control commands until the current client connection is closed so
    # the connection issuing the control command will never see its
    # result.
    CMD_ctrl=0x40  #  -- not a command - just a constant -- */
    CMD_ctrlEval=0x42  #  string : - */
    CMD_ctrlSource=0x45  #  string : - */
    CMD_ctrlShutdown=0x44  #  - : - */

    # /* 'internal' commands (since 0.1-9) */
    CMD_setBufferSize=0x081  #  [int sendBufSize]  this commad allow clients to request bigger buffer sizes if large data is to be transported from Rserve to the client. (incoming buffer is resized automatically) */
    CMD_setEncoding=0x082  #  string (one of "native","latin1","utf8") : -; since 0.5-3 */

    # /* special commands - the payload of packages with this mask does not contain defined parameters */

    CMD_SPECIAL_MASK=0xf0

    CMD_serEval=0xf5 #  serialized eval - the packets are raw serialized data without data header */
    CMD_serAssign=0xf6 #  serialized assign - serialized list with [[1]]=name, [[2]]=value */
    CMD_serEEval=0xf7 #  serialized expression eval - like serEval with one additional evaluation round */

    #  data types for the transport protocol (QAP1)do NOT confuse with XT_.. values.

    DT_INT=1  #  int */
    DT_CHAR=2  #  char */
    DT_DOUBLE=3  #  double */
    DT_STRING=4  #  0 terminted string */
    DT_BYTESTREAM=5  #  stream of bytes (unlike DT_STRING may contain 0) */
    DT_SEXP=10 #  encoded SEXP */
    DT_ARRAY=11 #  array of objects (i.e. first 4 bytes specify how many subsequent objects are part of the array; 0 is legitimate) */
    DT_LARGE=64 #  new in 0102: if this flag is set then the length of the object is coded as 56-bit integer enlarging the header by 4 bytes */

    ERROR_DESCRIPTIONS={
      ERR_auth_failed=>'auth.failed or auth.requested but no login came',
      ERR_conn_broken=>'connection closed or broken packet killed it',
      ERR_inv_cmd=>"unsupported/invalid command",
      ERR_inv_par=>"some parameters are invalid",
      ERR_Rerror=>"R-error",
      ERR_IOerror=>"I/O error",
      ERR_notOpen=>"attempt to perform fileRead/Write  on closed file",
      ERR_accessDenied=>"Access denied",
      ERR_unsupportedCmd=>"unsupported command",
      ERR_unknownCmd=>"unknown command",
      ERR_data_overflow=>"data overflow",
      ERR_object_too_big=>"requested object is too big",
      ERR_out_of_mem=>"out of memory",
      ERR_ctrl_closed=>"control pipe to the master process is closed or broken",
      ERR_session_busy=>"session still busy",
      ERR_detach_failed=>"unable to detach seesion"
    } # error descriptions
    # I have to use to support different archs
    MAX_LONG_SIGNED=2**31
    MAX_LONG_UNSIGNED=2**32

    # writes bit-wise int to a byte buffer at specified position in Intel-endian form
    # Internal: byte buffer will be the result of unpack("CCCC") an integer.
    # @param v value to be written
    # @param buf buffer
    # @param o offset in the buffer to start at. An int takes always 4 bytes */
    def  set_int(v, buf, o)
      buf[o]=(v&255);o+=1
      buf[o]=((v&0xff00)>>8); o+=1
      buf[o]=((v&0xff0000)>>16); o+=1
      buf[o]=((v&0xff000000)>>24);
    end

    # writes cmd/resp/type byte + 3/7 bytes len into a byte buffer at specified offset.
    # @param ty type/cmd/resp byte
    # @param len length
    # @param buf buffer
    # @param o offset
    # @return offset in buf just after the header. Please note that since Rserve 0.3 the header can be either 4 or 8 bytes long, depending on the len parameter.
    def set_hdr(ty, len, buf, o)
      buf[o]=((ty&255)|((len>0xfffff0) ? DT_LARGE : 0)); o+=1;
      buf[o]=(len&255); o+=1;
      buf[o]=((len&0xff00)>>8); o+=1;
      buf[o]=((len&0xff0000)>>16); o+=1;
      if (len>0xfffff0)  # for large data we need to set the next 4 bytes as well
        buf[o]=((len&0xff000000)>>24); o+=1;
        buf[o]=0; o+=1; # since len is int, we get 32-bits only
        buf[o]=0; o+=1;
        buf[o]=0; o+=1;
      end
      o
    end
    # creates a new header according to the type and length of the parameter
    # @param ty type/cmd/resp byte
    # @param len length
    def new_hdr(ty, len)
      hdr=Array.new(  (len>0xfffff0)?8:4)
      set_hdr(ty,len,hdr,0);
      hdr
    end
    #
    # converts bit-wise stored int in Intel-endian form into ruby int
    #
    # @param buf buffer containg the representation
    # @param o offset where to start (4 bytes will be used)
    # @return the int value. no bounds checking is done so you need to
    # make sure that the buffer is big enough

    def get_int(buf, o)
      buf[o,4].pack("C*").unpack("l")[0]
    end
    def get_int_original(buf,o) # :nodoc:
      v=((buf[o]&255)|((buf[o+1]&255)<<8)|((buf[o+2]&255)<<16)|((buf[o+3]&255)<<24))
      v >= MAX_LONG_SIGNED ? v-MAX_LONG_UNSIGNED : v
    end

    # converts bit-wise stored length from a header. "long" format is supported up to 32-bit
    # @param buf buffer
    # @param o offset of the header (length is at o+1)
    # @return length */
    def get_len(buf, o)
      # // "long" format; still - we support 32-bit only
      if  ((buf[o]&64)>0)
        #p "buf:#{buf} --- o: #{o} -- [#{buf[o+4]}]"
        raise "Buffer without enough values" if buf[o+4].nil?
        (buf[o+1]&255)|((buf[o+2]&255)<<8)|((buf[o+3]&255)<<16)|((buf[o+4]&255)<<24)
      else
        (buf[o+1]&255)|((buf[o+2]&255)<<8)|((buf[o+3]&255)<<16)
      end
    end

    # converts bit-wise Intel-endian format into long
    # @param buf buffer
    # @param o offset (8 bytes will be used)
    # @return long value */
    def get_long(buf, o)
      buf[o,8].pack("CCCCCCCC").unpack("Q")[0]
    end
    def get_long_original(buf,o)   #:nodoc:
      low=(get_int(buf,o))&0xffffffff;
      hi=(get_int(buf,o+4))&0xffffffff;
      hi<<=32; hi|=low;
      hi
    end
    
    def longBitsToDouble(bits)
      (bits==LONG_NA) ? Rserve::REXP::Double::NA : [bits].pack("Q").unpack("d")[0]
    end
    
    # Complete version of longBitsToDouble, as Java documentation established 
    def longBitsToDouble_old(bits) # :nodoc:
      s = ((bits >> 63) == 0) ? 1 : -1;
      e = ((bits >> 52) & 0x7ff)
      m = (e == 0) ?
      (bits & 0xfffffffffffff) << 1 :
      (bits & 0xfffffffffffff) | 0x10000000000000;
      s*m*2**(e-1075)
    end
    
    def doubleToRawLongBits(double)
      [double].pack("d").unpack("Q")[0]
    end
    def set_long(l, buf, o)
      set_int((l&0xffffffff), buf, o)
      set_int((l>>32),buf,o+4)
    end
  end
end

require_relative 'protocol/rexpfactory'
