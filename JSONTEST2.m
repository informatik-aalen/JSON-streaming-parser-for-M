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

txt ;{"a1": 123, "a2": [1,2], "a3": {"a":"1"}}
	;{"Hobbies":["Segelfliegen","Segeln"],"NN":"Mustermann","VN":"Hans","adresse":{"Ort":"Stuttgart","PLZ":70374} }
	;{"by":1967,"nn":"Bantel","children": ["Linus","Leandra"],"male":true,"female":false,"div":null }
