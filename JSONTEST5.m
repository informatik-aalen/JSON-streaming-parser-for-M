JSONTEST5   ;
	; Input: ^JSONTXT(...) multiline Global with hardcoded name
	; (could also be passed to getc / ungetc via lvn a or whatever)
	; Output: All scalar values and all (nested) property names (like JSONTEST0)
	;
	s ^JSONTXT(1)="{""nn"":""BaWi"",",^(2)="""vn"":""Winfried"",""dob"":2000101",^(3)="}"
	s ind="" f  s ind=$O(^JSONTXT(ind)) q:ind=""  w ^(ind),!
	k a
	s a("callback","skalar")="cbskalar^JSONTEST0",a("callback","start")="cbstart^JSONTEST0",a("callback","end")="cbend^JSONTEST0"
	s a("callback","getc")="getc^JSONTEST5",a("callback","ungetc")="ungetc^JSONTEST5"
	s result=$$^JSONPARSER(.a) w "result:",result,!
	q

getc(a)	;
	n (a)
	i '$D(a("lnr")) s a("lnr")=$O(^JSONTXT("")),a("pos")=0
	s a("pos")=a("pos")+1 i $L(^JSONTXT(a("lnr")))<a("pos") s a("lnr")=$O(^JSONTXT(a("lnr"))),a("pos")=1
	q $S(a("lnr")="":"",1:$E(^JSONTXT(a("lnr")),a("pos")))

ungetc(a) ;
	s a("pos")=a("pos")-1 i a("pos")=0 s a("lnr")=$O(^JSONTXT(a("lnr")),-1),a("pos")=$L(^JSONTXT(a("lnr")))
	q
