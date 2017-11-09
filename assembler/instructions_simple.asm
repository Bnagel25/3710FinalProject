;;;
;;; Prints out a 'A' @ addresss 0
;;;
; Store 1111 1111 at top 8 bits of r0
        lui %r10, 255
        lli %r10, 65
        sw %r10, 0
