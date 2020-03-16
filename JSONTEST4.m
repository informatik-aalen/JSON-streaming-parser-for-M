JSONTEST4   ;
	; Input: file /tmp/test.json
	; Output: All scalar values and all (nested) property names (like JSONTEST0)
	;
	k a s a("file")="/tmp/test.json" o a("file"):readonly
	s a("callback","skalar")="cbskalar^JSONTEST0",a("callback","start")="cbstart^JSONTEST0",a("callback","end")="cbend^JSONTEST0"
	s a("callback","getc")="getc^JSONTEST4",a("callback","ungetc")="ungetc^JSONTEST4"
	s result=$$^JSONPARSER(.a) w "result:",result,!
	c a("file")
	q

getc(a)	;
	n c
	u a("file") r *c u 0
	q $S($A(c)>0:$C(c),1:"")

ungetc(a) ;
	u a("file"):(seek=-1) u 0
	q
