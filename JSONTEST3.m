JSONTEST3   ;
	; Input: stdin
	; Output: All scalar values and all (nested) property names (like JSONTEST0)
	;
	k a
	; callback-functions in ^JSONTEST0 !!!
	s a("callback","skalar")="cbskalar^JSONTEST0",a("callback","start")="cbstart^JSONTEST0",a("callback","end")="cbend^JSONTEST0"
	s a("callback","getc")="getc^JSONTEST3",a("callback","ungetc")="ungetc^JSONTEST3"
	s result=$$^JSONPARSER(.a) w "result:",result,!
	q

	; callback-functions for reading stdin
	; Little bit tricky because fseek=-1 doesn't work for stdin !!!
	; getc and ungetc communicate via a("c0") and a("c1")
	;
getc(a)	;
	n c
	i $D(a("c1")) s c=a("c1") k a("c1") q $C(c)
	u 0 r *c s a("c0")=c ; remember for later ungetc
	q $S($A(c)>0:$C(c),1:"")


ungetc(a) ;
	s a("c1")=a("c0") ;
	q
