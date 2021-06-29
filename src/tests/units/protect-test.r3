Rebol [
	Title:   "Rebol protect test script"
	Author:  "Oldes"
	File: 	 %protect-test.r3
	Tabs:	 4
	Needs:   [%../quick-test-module.r3]
]

~~~start-file~~~ "Protect"

===start-group=== "Checks if protected data are really protected"
	bin: #{cafe}
	str:  "cafe"
	blk: ["cafe"]
	protect/values [bin str blk]

	is-protected-error?: function[code][
		true? all [
			error? err: try code
			err/id = 'protected
		]
	]

	--test-- "clear"   --assert is-protected-error? [clear bin]
	--test-- "append"  --assert is-protected-error? [append bin #{0bad}]
	--test-- "insert"  --assert is-protected-error? [insert bin #{0bad}]

	;@@ https://github.com/Oldes/Rebol-issues/issues/2321
	--test-- "encloak" --assert is-protected-error? [encloak bin "key"]
	--test-- "decloak" --assert is-protected-error? [decloak bin "key"]
	;@@ https://github.com/Oldes/Rebol-issues/issues/1780
	;@@ https://github.com/Oldes/Rebol-issues/issues/2272
	--test-- "remove-each" --assert is-protected-error? [remove-each a bin [a < 3]]
	;@@ https://github.com/Oldes/Rebol-issues/issues/1780
	--test-- "random block"  --assert is-protected-error? [random blk]
	--test-- "random string" --assert is-protected-error? [random str]
	--test-- "random binary" --assert is-protected-error? [random bin]

	--test-- "swap block"  --assert is-protected-error? [swap blk [0]]
	--test-- "swap string" --assert is-protected-error? [swap str "0bad"]
	--test-- "swap binary" --assert is-protected-error? [swap bin #{0bad}]

	;@@ https://github.com/Oldes/Rebol-issues/issues/2325
	str: protect "a^M^/b"
	--test-- "deline string"  --assert is-protected-error? [deline str]
	--test-- "enline string"  --assert is-protected-error? [enline str]

	--test-- "delect"
	;@@ https://github.com/Oldes/Rebol-issues/issues/1783
	dialect: context [default: [tuple!]]
	inp: [1.2.3]
	out: make block! 4
	protect out
	--assert is-protected-error? [delect dialect inp out]

	--test-- "protect bitset"
	;@@ https://github.com/Oldes/Rebol-issues/issues/977
		ws: protect charset "^- "
		--assert is-protected-error? [clear ws  ]
		--assert is-protected-error? [ws/1: true]

===end-group===

~~~end-file~~~