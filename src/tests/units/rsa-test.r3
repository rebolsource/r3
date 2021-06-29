Rebol [
	Title:   "Rebol3 RSA test script"
	Author:  "Oldes, Peter W A Wood"
	File: 	 %rsa-test.r3
	Tabs:	 4
	Needs:   [%../quick-test-module.r3]
]

~~~start-file~~~ "RSA"

===start-group=== "RSA crypt"

	ko: object [
		n: #{
		D2FC7B6A0A1E6C67104AEB8F88B257669B4DF679DDAD099B5C4A6CD9A88015B5
		A133BF0B856C7871B6DF000B554FCEB3C2ED512BB68F145C6E8434752FAB52A1
		CFC124408F79B58A4578C16428855789F7A249E384CB2D9FAE2D67FD96FB926C
		198E077399FDC815C0AF097DDE5AADEFF44DE70E827F4878432439BFEEB96068
		D0474FC50D6D90BF3A98DFAF1040C89C02D692AB3B3C2896609D86FD73B774CE
		0740647CEEEAA310BD12F985A8EB9F59FDD426CEA5B2120F4F2A34BCAB764B7E
		6C54D6840238BCC40587A59E66ED1F33894577635C470AF75CF92C20D1DA43E1
		BFC419E222A6F0D0BB358C5E38F9CB050AEAFE904814F1AC1AA49CCA9EA0CA83
		}
		e: #{010001}
		d: #{
		5F8713B5E258FE09F81583EC5C1F2B7578B1E6FC2C83514B37913711A1BA449A
		151FE1CB2CA0FD33B771E68A3B1944649DC867AD1C1E5240BB853E5F24B33459
		B14028D2D6636BEFEC1E8DA974B352FC53D3F6127EA8A3C29DD14F3941682C56
		A78768164E4DDA8F06CBF9C734AAE8003224278EA9454A21B17CB06D17807586
		8CC05B3DB6FF1DFDC3D56378B4EDADEDF0C37A4CDC26D1D49AC26F6FE3B5220A
		5DD29396621BBC688CF2EEE2C6E0D54DA3C782014CD0739DB252CC51CAEBA8D3
		F1B824BAAB24D068EC903264D7D678AB08F06EC9E7E23D960628B744BF94B369
		4656463C7E417399ED73D076C891FCF463A9AA9CE62DA9CD17E237DC2A8002F1
		}
		p: #{
		F378BEEC8BCC197A0C5C2B24BFBDD32ABF3ADFB1623BB676EF3BFCA23EA96D65
		10C8B3D0050C6D3D59F00F6D11FBAD1E4C3983DAE8E732DE4FA2A32B9BC45F98
		D855583B638CC9823233A949789C1478FB5CEB95218432A955A558487A74DDFA
		19565893DDCDF0173DBD8E35C72F01F51CF3386550CD7BCD12F9FB3B49D56DFB
		}
		q: #{
		DDD7CE47D72E62AFB44BE9A414BCE022D80C11F173076AB78567A132E1B4A02B
		AA9DBDEFA1B2F2BA6AA355940ED5D22B7708139C276963305C39F5B9AF7EF400
		55E38967EDFCD1848A8BE89E2CE12A9A3D5554BBF13CC583190876B79C45ECEC
		67ED6461DFECD6A0DBC6D9031207C0213006F4B527003BA7E2F21C6FAC9E9719
		}
		dp: #{
		1B8B0F5E473A61AF72F28256F7F20B8F8C6EA69BB49738BF1FB553912F318F94
		9D5F7728134A22998C31222D9E99302E7B450E6B97698051B2049E1CF2D43654
		5E34D9746E80A0D33FC6A4621168E6D000EFB41EFCD9ADB9865CDC2DE6DC8DB8
		1B61AF479B120F153200DDB3ABC2DF9FD1149ACEAB63739BF187A22A44E2063D
		}
		dq: #{
		B3D9401FD7E0801B28151F0E69CD91FC4DA0C36F36AD3DA418E021BC89651131
		3579FAC0EA1B9452F31F05C3299FC96A796EAFCF39D8639492405EE931D0BF6A
		02379C6F086E9D4151BD09522ADA44DA947CB85C41BFDDF461780E1EDEEF859B
		46CA1B4689EE8D360DD7109A3FA4CEEB58EF5AB5FE2F5F2DC57C38F7843F7209
		}
		qi: #{
		1B233FA7A26B5F24A2CF5B6816029B595F89748DE3438CA9BBDADB316C77AD02
		417E6B7416863381421911514470EAB07A644DF35CE80C069AF819342963460E
		3247643743985856DC037B948FA9BB193F987646275D6BC7247C3B9E572D27B7
		48F9917CAC1923AC94DB8671BD0285608B5D95D50A1B33BA21AEB34CA8405515
		}
	]
	--test-- "Init RSA keys"
		--assert handle? key-pub:  rsa-init ko/n ko/e ;<-- this key has only public properties
		--assert handle? key-pri:  rsa-init/private ko/n ko/e ko/d ko/p ko/q ko/dp ko/dq ko/qi
		--assert "#[handle! rsa]" = mold key-pub
		--assert "#[handle! rsa]" = mold key-pri

	;-- note: you could use key-pri only as it contains the public properties too
	;-- the key-pub is there just to simulate situation, where user have only the public parts

	--test-- "RSA encrypt"
		;you can use both keys for encryption (only the public parts are used)
		--assert binary? secret: rsa/encrypt key-pub #{41686F6A21}
		--assert binary?         rsa/encrypt key-pri #{41686F6A21}

	--test-- "RSA decrypt"
		;decrypting needs private parts in the key
		--assert #{41686F6A21} = rsa/decrypt key-pri secret 
		--assert         none?   rsa/decrypt key-pub secret ;because private key is needed

	--test-- "RSA signing"
		;signing needs private parts in the key
		--assert binary? sign-hash: rsa/sign key-pri #{41686F6A21}
		--assert              none? rsa/sign key-pub #{41686F6A21} ;because private key is needed

	--test-- "RSA verification"
		;you can use both keys for verification (only the public parts are used)
		--assert #{41686F6A21} = rsa/verify key-pub sign-hash
		--assert #{41686F6A21} = rsa/verify key-pri sign-hash

	--test-- "RSA key release"
		;once RSA key is not needed, release the resources using NONE data
		--assert rsa key-pub none
		--assert rsa key-pri none

===end-group===


===start-group=== "RSA initialization using codecs"
	--test-- "RSA sign/verify using external file"
	; Bob has data, which wants to sign, so it's clear, that nobody modifies them
	data: "Hello!"
	; As RSA is slow, it is used on hashes.. for example SHA1
	hash: checksum data 'sha1
	; Bob uses private key which keeps secret...
	--assert handle? try [private-key: load %units/files/rebol-private-no-pass.ppk]
	; .. to sign the hash..
	--assert binary? signed-hash: rsa/sign private-key hash

	; than sends data, and signed hash to Eve, who have his public key 
	--assert handle? try [public-key: load %units/files/rebol-public.ppk]
	; Eve uses the key to verify the checksum...
	--assert (checksum data 'sha1) = rsa/verify public-key signed-hash
	; so she know, that data were not modified

	; cleanup:
	rsa public-key none
	rsa private-key none
===end-group===

===start-group=== "RSA initialization from file"
	--test-- "RSA private key from OpenSSL format"
	--assert handle? try [private-key: load %units/files/rebol-private-no-pass.key]
	; cleanup:
	rsa private-key none
===end-group===



~~~end-file~~~