JSONTEST1    ;
	; Input: Single string (callback in ^JSONPARSER)
	; Output: only property vn
	;
	k a s a=$P($T(txt),";",2,2000)
	s a("callback","skalar")="cbskalar^JSONTEST1",a("callback","start")="cbstart^JSONTEST1",a("callback","end")="cbend^JSONTEST1"
	s a("callback","getc")="getc",a("callback","ungetc")="ungetc"
	s result=$$^JSONPARSER(.a) w "result:",result,!,"vn=",a("vn"),!
	q
txt ;{"nn":"Mustermann","vn":"Hans","dob":2000101}

cbskalar(l,t,txt)
	n (l,t,txt,data)
	if $G(data("attention"))="vn" k data("attention") s data("vn")=txt
	q

cbstart(l,txt)
	n (l,txt,data)
	i $G(txt)="vn" s data("attention")="vn"
	q

cbend(l,txt)
	q
