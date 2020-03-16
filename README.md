# JSON-Streaming-API for M

A very light JSON-parser written in native M. Input and output is controlled
by callback-functions.

## Licence
(c) 2000 Winfried Bantel
Published under MIT-License.  
https://en.wikipedia.org/wiki/MIT_License

Absolutely no warranty!

## How to use
Set a local variable with at least five values for callback-functions.
Optional add mor content like JSON-text ore more.

## Provided Callback-Functions
The following callback-functions ar provided with the parser:

domcbskalar to build a DOM-tree   
domcbstart to build a DOM-tree   
domcbend to build a DOM-tree  
getc which reads th input from the root-entry of the tree passed to the parser  
ungetc analogous to getc

## Interface
Example: s result=$$^JSONPARSER(.data)  
Parameter:

1: An array which at least points to the five callback-functions, the array mst be passed by reference:  
("callback","end")="..."  
("callback","getc")="..."  
("callback","skalar")="..."  
("callback","start")="..."  
("callback","ungetc")="..."  
This array will in turn be passed to the callback-functions getc and ungetc and will be
visible in the callback-functions start, end and skalar.  
Return-value: Zero if the syntax was correct or non-zero  otherwise



## Write specific Callback-Functions
### skalar
This function is called when the parser finds a scalar value.

Parameters:

1: An array which gives information about the counting numbers in each level  
2: Type of the scalar value (string, number and so on)  
3: The value itself

Return-value: No return-Value  
Recommendation: NEW all variables except the paramters and evtl. data (this is the data passed to the parser)

### start
This function is called when the parser finds a new element.

Parameters:

1: An array which gives information about the counting numbers in each level  
2: The name of the element if it is a JSON-property, otherwise not set

Return-value: No return-Value  
Recommendation: NEW all variables except the paramters and evtl. data (this is the data passed to the parser)

### end
This function is called when the parser finds the end of an element.

Parameters:

1: An array which gives information about the counting numbers in each level  
2: The name of the element if it is a JSON-property, otherwise not set

Return-value: No return-Value  
Recommendation: NEW all variables except the paramters and evtl. data (this is the data passed to the parser)

### getc
This function is called when the scanner needs the next character.

Parameters:

1: The array which was passed to the parser with all info  

Return-value: The next char or an empty string if end-of-input was reached.  
Recommendation: NEW all variables except the paramter

### ungetc
This function is called when the scanner needs push-back the last input.

Parameters:

1: The array which was passed to the parser with all info  

Return-value: No return-Value  
Recommendation: NEW all variables except the paramter

## Examples
### JSONTEST0
Reads JSON from local variable and writes streaming info.
### JSONTEST1
Reads JSON from local variable and selects / writes specific value.
### JSONTEST2
Reads JSON from local variable and build DOM-tree.
### JSONTEST3
Reads JSON from stdin and writes streaming info.
### JSONTEST4
Reads JSON from file and writes streaming info.

Due to file-operations this is the only example which contains YottaDB- / GT.M-specific code and therefore
will not run in other M-Systems.
### JSONTEST5
Reads JSON from multiline-global and writes streaming info.

