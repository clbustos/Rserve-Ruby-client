module Rserve
  # representation of R-eXpressions in Java
  # I didn't decide if better implementation of this is a Module or a Class
  class Rexp
    
  #/* XpressionTypes
  #   REXP - R expressions are packed in the same way as command parameters
  #   transport format of the encoded Xpressions:
  #   [0] int type/len (1 byte type, 3 bytes len - same as SET_PAR)
  #   [4] REXP attr (if bit 8 in type is set)
  #   [4/8] data .. */
  
  XT_NULL=0  #  P  data: [0] */
  XT_INT=1  #  -  data: [4]int */
  XT_DOUBLE=2  #  -  data: [8]double */
  XT_STR=3  #  P  data: [n]char null-term. strg. */
  XT_LANG=4  #  -  data: same as XT_LIST */
  XT_SYM=5  #  -  data: [n]char symbol name */
  XT_BOOL=6  #  -  data: [1]byte boolean (1=TRUE, 0=FALSE, 2=NA) */
  XT_S4=7  #  P  data: [0] */
  XT_VECTOR=16 #  P  data: [?]REXP,REXP,.. */
  XT_LIST=17 #  -  X head, X vals, X tag (since 0.1-5) */
  XT_CLOS=18 #  P  X formals, X body  (closure; since 0.1-5) */
  XT_SYMNAME=19 #  s  same as XT_STR (since 0.5) */
  XT_LIST_NOTAG=20 #  s  same as XT_VECTOR (since 0.5) */
  XT_LIST_TAG=21 #  P  X tag, X val, Y tag, Y val, ... (since 0.5) */
  XT_LANG_NOTAG=22 #  s  same as XT_LIST_NOTAG (since 0.5) */
  XT_LANG_TAG=23 #  s  same as XT_LIST_TAG (since 0.5) */
  XT_VECTOR_EXP=26 #  s  same as XT_VECTOR (since 0.5) */
  XT_VECTOR_STR=27 #  -  same as XT_VECTOR (since 0.5 but unused, use XT_ARRAY_STR instead) */
  XT_ARRAY_INT=32 #  P  data: [n*4]int,int,.. */
  XT_ARRAY_DOUBLE=33 #  P  data: [n*8]double,double,.. */
  XT_ARRAY_STR=34 #  P  data: string,string,.. (string=byte,byte,...,0) padded with '\01' */
  XT_ARRAY_BOOL_UA=35 #  -  data: [n]byte,byte,..  (unaligned! NOT supported anymore) */
  XT_ARRAY_BOOL=36 #  P  data: int(n),byte,byte,... */
  XT_RAW=37 #  P  data: int(n),byte,byte,... */
  XT_ARRAY_CPLX=38 #  P  data: [n*16]double,double,... (Re,Im,Re,Im,...) */
  XT_UNKNOWN=48 # P  data: [4]int - SEXP type (as from TYPEOF(x)) */ #                             
  XT_LARGE=64 #  new in 0102: if this flag is set then the length of the object is coded as 56-bit integer enlarging the header by 4 bytes */
  XT_HAS_ATTR=128 #  flag; if set, the following REXP is the attribute */
  end
end