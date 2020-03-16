JSONPARSER(data)	;; Version 20200316
	;;
	;; JSON-Streaming-Parser in M
	;; (c) 2020 Winfried Bantel
	;; Published under MIT-License https://de.wikipedia.org/wiki/MIT-Lizenz
	;;

	n (data)
	s error=0 d scan,value i token'="" d error(-3)
	q error

	;; Helper functions
forward()
	q @("$$"_data("callback","getc")_"(.data)")

backward()
	d @(data("callback","ungetc")_"(.data)")
	q

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
	s c=$$forward() f  q:($C(9,10,13,32)'[c)!(c="")  s c=$$forward()
    i "{}[],:"[c s (token,text)=c q
	s token=""
    i c="""" s text="" d  s token="string"  q
    . f  s c=$$forward() q:c=""""  s text=text_c
    i c?1N s text=c d  d backward s:token="" token="number" q
    . f  s c=$$forward() q:c'?1N  s text=text_c
	. i c="." s text=text_".",c=$$forward() d
	. . i c?1N d
	. . . f  s text=text_c,c=$$forward() q:c'?1N
	. . e  d
	. . . s token="error"
	. i (c="E")!(c="e") s text=text_c,c=$$forward() d
	. . i (c="+")!(c="-") s text=text_c,c=$$forward()
	. . i c?1N d
	. . . f  s text=text_c,c=$$forward() q:c'?1N
	. . e  d
	. . . s token="error"
	i c="t" s text=c_$$forward()_$$forward()_$$forward() i text="true" s token="true" q
	i c="f" s text=c_$$forward()_$$forward()_$$forward()_$$forward() i text="false" s token="false" q
	i c="n" s text=c_$$forward()_$$forward()_$$forward() i text="null" s token="null" q
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

	;; getc and ungetc Callback for JSON in root-entry of parameter data
getc(a)	;
	q $E(a,$incr(a("nr")))

ungetc(a) ;
	s a("nr")=$incr(a("nr"),-1)
	q
