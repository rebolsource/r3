REBOL [
	System: "REBOL [R3] Language Interpreter and Run-time Environment"
	Title: "REBOL 3 Boot Base: Debug Functions"
	Rights: {
		Copyright 2012 REBOL Technologies
		REBOL is a trademark of REBOL Technologies
	}
	License: {
		Licensed under the Apache License, Version 2.0
		See: http://www.apache.org/licenses/LICENSE-2.0
	}
	Note: {
		This code is evaluated just after actions, natives, sysobj, and other lower
		levels definitions. This file intializes a minimal working environment
		that is used for the rest of the boot.
	}
]

probe: func [
	{Debug print a molded value and returns that same value.}
	value [any-type!]
][
	print mold :value
	:value
]

??: func [
	{Debug print a word, path, or block of such, followed by its molded value.}
	'name "Word, path or block to obtain values."
][
	case [
		any [
			word? :name
			path? :name
		][
			prin ajoin ["^[[1;32;49m" mold :name "^[[0m: ^[[32m"] 
    		prin either value? :name [mold/all get/any :name] ["#[unset!]"]
    		print "^[[0m"
		]
		block? :name [
			foreach word name [
				either any [
					word? :word
					path? :word
				][
					prin ajoin ["^[[1;32;49m" mold :word "^[[0m: ^[[32m"] 
					prin either value? :word [mold/all get/any :word]["#[unset!]"]
					print "^[[0m"
				][
					print ajoin ["^[[1;32;49m" mold/all word "^[[0m"]
				]
			]
		]
		true [print ajoin ["^[[1;32;49m" mold/all :name "^[[0m"]]
	]
	exit
]

boot-print: func [
	"Prints when not quiet."
	data
][
	unless system/options/quiet [print :data]
]

loud-print: func [
	"Prints when verbose."
	data
][
	if system/options/flags/verbose [print :data]
]
