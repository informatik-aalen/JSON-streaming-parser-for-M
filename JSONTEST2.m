JSONTEST2    ;
	; Input: Single string (callback in ^JSONPARSER)
	; Output: DOM in ^JSONIMPORT($J)
	;
	k a s a=$P($T(txt),";",2,2000)
	s a("callback","skalar")="domcbskalar",a("callback","start")="domcbstart",a("callback","end")="domcbend"
	s a("callback","getc")="getc",a("callback","ungetc")="ungetc"
	k ^JSONIMPORT
	s result=$$^JSONPARSER(.a) w "result:",result,!
	zwr ^JSONIMPORT
	q

txt ;{"a1": 123.1, "a2": [1,2], "a3": {"a":"1"}}
	;{"Hobbies":["music","cinema"],"NN":"Mustermann","VN":"Hans","adresse":{"Ort":"Stuttgart","PLZ":70374} }
	;{"by":1967,"nn":"Mustermann","children": ["child-1","child-2"],"male":true,"female":false,"div":null }
