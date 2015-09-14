REBOL [
	System: "REBOL [R3] Language Interpreter and Run-time Environment"
	Title: "REBOL 3 Mezzanine: Legacy compatibility"
	Rights: {
		Copyright 1997-2015 REBOL Technologies
		Copyright 2012-2015 Rebol Open Source Contributors

		REBOL is a trademark of REBOL Technologies
	}
	License: {
		Licensed under the Apache License, Version 2.0
		See: http://www.apache.org/licenses/LICENSE-2.0
	}
	Description: {
		These definitions turn the clock backward for Rebol code that was
		written prior to Ren/C, e.g. binaries available on rebolsource.net
		or R3-Alpha binaries from rebol.com.  Some flags which are set
		which affect the behavior of natives and the evaluator ARE ONLY
		ENABLED IN DEBUG BUILDS OF REN/C...so be aware of that.

		Some "legacy" definitions (like `foreach` as synonym of `for-each`)
		are kept by default for now, possibly indefinitely.  For other
		changes--such as variations in behavior of natives of the same
		name--you need to add the following to your code:

			do <r3-legacy>

		(Dispatch for this from DO is in the DO* function of sys-base.r)

		This statement will be a NO-OP in older Rebols, since executing a
		tag evaluates to just a tag.  Note that the current trick will
		modify the user context directly, and is not module-based...so
		you really are sort of "backdating" the system globally.  A
		more selective version that turns features on and off one at
		a time to ease porting is needed, perhaps like:

			do/args <r3-legacy> [
				new-do: off
				question-marks: on
			]

		As always, feedback and improvement welcome.  A porting guide Trello
		has been started at:

			https://trello.com/b/l385BE7a/porting-guide
	}
]

op?: func [
	"Returns TRUE if the argument is an ANY-FUNCTION? and INFIX?"
	value [any-type!]
][
	either any-function? :value [:infix? :value] false
]


; It would be nicer to use type!/type? instead of datatype!/datatype?  :-/
; The compatibility layer may have to struggle with that change down the line
;
; The previous /WORD refinement was common because things like SWITCH
; statements wanted to operate on the word for the datatype, since in
; unevaluated contexts INTEGER! would be a WORD! and not a DATATYPE!.  With
; change to allow lax equality comparisons to see a datatype and its word
; as being equal, this is not as necessary.  Cases that truly need it can
; use TO-WORD TYPE-OF.
;
type?: function [
	"Returns the datatype of a value <r3-legacy>."
	value [any-type!]
	/word "No longer in TYPE-OF, as WORD! and DATATYPE! can be EQUAL?"
][
	either word [
		; Right now TO-WORD is still returning PAREN! for a PAREN! type,
		; so the EITHER isn't necessary.  But it's a talking point about
		; TYPE?/WORD's compatibility story if TO-WORD changed.
		;
		either word: to-word type-of :value = 'group! [paren!] [word]
	][
		type-of :value
	]
]


; See also prot-http.r, which has an actor with a LENGTH? "method".  Given
; how actors work, it cannot be overriden here.
length?: :length

index?: :index-of

offset?: :offset-of

sign?: :sign-of


; While `foreach` may have been comfortable for some as a word, its hard
; not to see the word `reach` inside of it.  Once you recognize that it's
; not a word and see it with fresh eyes, it looks bad...and also not part
; of the family of other -each functions like `remove-each` and `map-each`.
; The need for the hyphen for `for-each` isn't that bad, but the hyphen
; does break the rhythm a little bit.  `every` was selected as a
; near-synonym of `for-each` (with a different return result).
;
; Because there is no eager need to retake foreach for any other purpose
; and it doesn't convey any fundamentally incorrect idea, it is low on
; the priority list to eliminate completely.  It may be retained as a
; synonym, and `each` may be considered as well.  The support of synonyms
; is controversial and should be balanced against the value of standards.
;
foreach: :for-each


; The distinctions between Rebol's types is important to articulate.
; So using the term "BLOCK" generically to mean any composite
; series--as well as specificially the bracketed block type--is a
; recipe for confusion.
;
; Importantly: it also makes it difficult to get one's bearings
; in the C sources.  It's hard to find where exactly the bits are in
; play that make something a bracketed block...or if that's what you
; are dealing with at all.  Hence some unique name for the typeclass
; is needed.
;
; The search for a new word for the ANY-BLOCK! superclass went on for
; a long time.  LIST! was looking like it might have to be the winner,
; until ARRAY! was deemed more fitting.  The notion that a "Rebol
; Array" contains "Rebol Values" that can be elements of any type
; (including other arrays) separates it from the other series classes
; which can only contain one type of element (codepoints for strings,
; bytes for binaries, numbers for vector).  In the future those may
; have more unification under a typeclass of their own, but ARRAY!
; is for BLOCK!, PAREN!, PATH!, GET-PATH!, SET-PATH!, and LIT-PATH!

any-block!: :any-array!
any-block?: :any-array?


; !!! These have not been renamed yet, because of questions over what they
; actually return.  CONTEXT-OF was a candidate, however the current behavior
; of just returning TRUE from BIND? when the word is linked to a function
; arg or local is being reconsidered to perhaps return the function, and to
; be able to use functions as targets for BIND as well.  So binding-of might
; be the better name, or bind-of as it's shorter.

;bind?
;bound?


; !!! These less common cases still linger as question mark routines that
; don't return LOGIC!, and they seem like they need greater rethinking in
; general. What replaces them (for ones that are kept) might be entirely new.

;encoding?
;file-type?
;speed?
;suffix?
;why?
;info?
;exists?


; In word-space, TRY is very close to ATTEMPT, in having ambiguity about what
; is done with the error if one happens.  It also has historical baggage with
; TRY/CATCH constructs. TRAP does not have that, and better parallels CATCH
; by communicating you seek to "trap errors in this code (with this handler)"
; Here trapping the error suggests you "caught it in a trap" and it is
; in the trap (and hence in your possession) to examine.  /WITH is not only
; shorter than /EXCEPT but it makes much more sense.
;
; !!! This may free up TRY for more interesting uses, such as a much shorter
; word to use for ATTEMPT.  Even so, this is not a priority at this point in
; time...so TRY is left to linger without needing `do <r3-legacy>`
;
try: func [
	<transparent>
	{Tries to DO a block and returns its value or an error.}
	block [block!]
	/except "On exception, evaluate this code block"
	code [block! any-function!]
][
	either except [trap/with block :code] [trap block]
]


; To invoke this function, use `do <r3-legacy>` instead of calling it
; directly, as that will be a no-op in older Rebols.  Notice the word
; is defined in sys-base.r, as it needs to be visible pre-Mezzanine
;
set 'r3-legacy* func [] [

	; NOTE: these flags only work in debug builds.  A better availability
	; test for the functionality is needed, as these flags may be expired
	; at different times on a case-by-case basis.
	;
	system/options/do-runs-functions: true
	system/options/do-raises-errors: true
	system/options/broken-case-semantics: true
	system/options/exit-functions-only: true
	system/options/datatype-word-strict: true
	system/options/refinements-true: true

	; False is already the default for this switch
	; (e.g. `to-word type-of quote ()` is the word PAREN! and not GROUP!)
	;
	system/options/group-not-paren: false

	append system/contexts/user compose [

		and: (:and*)

		or: (:or+)

		xor: (:xor-)

		; Add simple parse back in by delegating to split, and return a LOGIC!
		parse: (function [
			{Parses a string or block series according to grammar rules.}
			input [series!] "Input series to parse"
			rules [block! string! none!] "Rules (string! is <r3-legacy>, use SPLIT)"
			/case "Uses case-sensitive comparison"
			/all "Ignored refinement for <r3-legacy>"
		][
			lib/case [
				none? rules [
					split input charset reduce [tab space cr lf]
				]

				string? rules [
					split input to-bitset rules
				]

				true [
					; !!! We could write this as:
					;
					;     lib/parse/:case input rules
					;
					; However, system/options/refinements-true has been set.
					; We could move the set to after the function is defined,
					; but probably best since this is "mixed up" code to use
					; the pattern that works either way.
					;
					true? apply :lib/parse [input rules case]
				]
			]
		])
	]

	return none
]
