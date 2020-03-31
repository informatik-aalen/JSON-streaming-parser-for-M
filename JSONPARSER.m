JSONPARSER(data)	;; Version 20200316
	;;
	;; JSON-Streaming-Parser in M
	;; (c) 2020 Winfried Bantel
	;; Published under MIT-License https://de.wikipedia.org/wiki/MIT-Lizenz
	;;

	n (data)
	s error=0 d scan,value i token'="" d error(-3)
	q error

error(err)
	s error=err
	q

match(t,err)
	i token=t d scan q
	d error(err)
	q

	;; Recursive-Descent-Parser
value ;
	s level($incr(level))=0
	i token="{" d
	. d object
	e  i token="[" d
	. d array
	e  i (token="string")!(token="number")!(token="true")!(token="false")!(token="null") d
	. d @(data("callback","skalar")_"(.level,.token,.text)"),scan
	e  d error(-4)
	k level(level) s level=level-1
	q

array
	d match("[",-1),@(data("callback","start")_"(.level)")
	i (token'="]") d
	. d value f  q:token'=","  s dummy=$incr(level(level)) d scan,value
	d match("]",-2),@(data("callback","end")_"(.level)")
	q

object
	d match("{",-1)
	d pair f  q:token'=","  s dummy=$incr(level(level)) d scan,pair
	d match("}",-1)
	q

pair
	n tpair s tpair=text
	d @(data("callback","start")_"(.level,tpair)")
	d match("string",-5),match(":",-6),value
	d @(data("callback","end")_"(.level,tpair)")
	q

	;; Scanner
scan
	; ToDo:
	; Escape-Characters in Strings (and Unicode-Characters)
	;
	n (text,token,data)
	s @("c=$$"_data("callback","getc")_"(.data)")
	f  q:($C(9,10,13,32)'[c)!(c="")  s @("c=$$"_data("callback","getc")_"(.data)")
    i "{}[],:"[c s (token,text)=c q
	s token=""
    i c="""" s text="" d  s token="string"  q
    . f  s @("c=$$"_data("callback","getc")_"(.data)") q:c=""""  s text=text_c
    i c?1N s text=c d  d @(data("callback","ungetc")_"(.data)") s:token="" token="number" q
    . f  s @("c=$$"_data("callback","getc")_"(.data)") q:c'?1N  s text=text_c
	. i c="." s text=text_".",@("c=$$"_data("callback","getc")_"(.data)") d
	. . i c?1N d
	. . . f  s text=text_c,@("c=$$"_data("callback","getc")_"(.data)") q:c'?1N
	. . e  d
	. . . s token="error"
	. i (c="E")!(c="e") s text=text_c,@("c=$$"_data("callback","getc")_"(.data)") d
	. . i (c="+")!(c="-") s text=text_c,@("c=$$"_data("callback","getc")_"(.data)")
	. . i c?1N d
	. . . f  s text=text_c,@("c=$$"_data("callback","getc")_"(.data)") q:c'?1N
	. . e  d
	. . . s token="error"
	i c="t" d  s token=$S(text="true":"true",1:"error") q
	. s text=c f i=1:1:3 s @("text=text_$$"_data("callback","getc")_"(.data)")
	i c="f" d  s token=$S(text="false":"false",1:"error") q
	. s text=c f i=1:1:4 s @("text=text_$$"_data("callback","getc")_"(.data)")
	i c="n" d  s token=$S(text="null":"null",1:"error") q
	. s text=c f i=1:1:3 s @("text=text_$$"_data("callback","getc")_"(.data)")
    s token="error" q

	;; Callback-Functions for DOM-Creation
domcbskalar(l,t,txt)
	n (l,t,txt,data)
	s glo=$S($D(data("domdest")):data("domdest"),1:"^JSONIMPORT($J")
	f i=1:1:l s glo=glo_","_l(i)
	s @(glo_")")=txt,@(glo_",""type"")")=t
	q

domcbstart(l,txt)
	n (l,txt,data)
	i $D(txt) d
	. s glo=$S($D(data("domdest")):data("domdest"),1:"^JSONIMPORT($J")
	. f i=1:1:l s glo=glo_","_l(i)
	. s @(glo_")")=txt
	q

domcbend(l,txt)
	q

	;; getc and ungetc Callback for JSON-string in root-entry of parameter data
getc(a)	;
	q $E(a,$incr(a("nr")))

ungetc(a) ;
	s a("nr")=$incr(a("nr"),-1)
	q
