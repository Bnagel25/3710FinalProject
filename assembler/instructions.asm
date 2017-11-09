;;;
;;; Program will will put [0-9] in the top corner of the screen
;;;
; putting 65280 @ address 0 is how we would display '0'
; Load 1111 1111 into r0
        lui %r10, 255
; Load 48 --> 0 into r0
        lli %r10, 48
; Lood 1111 1111 into r4
        lui %r4, 255
; Load 57 into r4
        lli %r4, 57
; Load 'cmp' variable, by clearing and loading check value of 255
        sub %r2, %r2
        addi %r2, 255
; If 255 is too small, lui, lli to r2 and compare that way

Load:
; Store r1 into address 0
        sw %r10, 0
; Load 'i' variable
        sub %r1, %r1

Loop:
; Increment i variable
        addi %r1, 1
; If i < 100 then jump
        cmp %r2, %r1
; 0000 =, 0001 !=, 0010 <, 0011 <=,
; Branch if r2 less than(r2) r1
        br %r2, Loop
; If r10 = r4, then reset r10
        cmp %r4, %r10
        br %r10, Reset
; Else add 1 to r10
        addi %r10, 1
; Jump back to Load
        jmp Load
Reset:
; Reset r10 back to 0, once it hits 9
        lli %r10, 48
; Jump back to load for another iteration
        jmp Load

