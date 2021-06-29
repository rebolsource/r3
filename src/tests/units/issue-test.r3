Rebol [
	Title:   "Rebol3 issue test script"
	Author:  "Oldes, Peter W A Wood"
	File: 	 %issue-test.r3
	Tabs:	 4
	Needs:   [%../quick-test-module.r3]
]



~~~start-file~~~ "ISSUE"

===start-group=== "to-hex"

	--test-- "to-hex integer!"
		--assert #0000000000000001 = to-hex 1
		--assert #00000000000000FF = to-hex 255

	--test-- "to-hex tuple!"
		--assert #010203 = to-hex 1.2.3
		--assert #01020304 = to-hex 1.2.3.4
		--assert #0102030405060708090A = to-hex 1.2.3.4.5.6.7.8.9.10

	--test-- "to-hex/size integer!"
		--assert #1 = to-hex/size 1 1
		--assert #01 = to-hex/size 1 2
		--assert #0000000000000001 = to-hex/size 1 99
		--assert error? try [to-hex/size 1  0] 
		--assert error? try [to-hex/size 1 -1]

	--test-- "to-hex/size tuple!"
		--assert #010203   = to-hex/size 1.2.3 8       ; doesn't pad the tuple!
		--assert #01020304 = to-hex/size 1.2.3.4.5.6 8 ; truncates the tuple!
		--assert error? try [to-hex/size 1.2.3  0] 
		--assert error? try [to-hex/size 1.2.3 -1] 

	--test-- "to-hex char!" ; not supported by design!
	;@@ https://github.com/Oldes/Rebol-issues/issues/1106
	;@@ https://github.com/Oldes/Rebol-issues/issues/1109
		--assert error? try [to-hex #"a"]

	--test-- "to-hex money!" ; not supported by design!
	;@@ https://github.com/Oldes/Rebol-issues/issues/1023
		--assert error? try [to-hex $0]
		

===end-group===

~~~end-file~~~
