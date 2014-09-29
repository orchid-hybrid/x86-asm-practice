
;; 64 bits = 8 bytes

(define (emit inst)
  (display "       ")
  (for-each (lambda (a) (display " ") (display a)) (list (car inst) (cadr inst)))
  (for-each (lambda (a) (display ",") (display a)) (cddr inst))
  (newline))

(define base-pointer
  (let ((rbp 0))
    (lambda ()
      (set! rbp (+ rbp 8))
      rbp)))


(define (push-number n)
  (emit `(mov rax ,n))
  (emit `(shl rax 4))
  (emit `(or rax 0b0001)) ; number tag is 0b0001
  (emit `(push rax))
  (base-pointer))

(define (push-cons kar kdr)
  (emit `(mov rax rbp))
  (emit `(sub rax ,kdr))
  (emit `(push rax))
  (emit `(mov rax rbp))
  (emit `(sub rax ,kar))
  (emit `(shl rax 4))
  ;(emit `(or rax 0b000)) ; cons tag is 0
  (emit `(push rax))
  (base-pointer)
  (base-pointer)
  )

(define (compile-tree tree)
  (if (number? tree)
      (push-number tree)
      (begin
        (let* ((kar (compile-tree (car tree)))
               (kdr (compile-tree (cdr tree))))
          (push-cons kar kdr)))))


;; (let ((root (compile-tree '((#x66 . #x77) . (#x8989 . #x4141)))))
;;   (emit `(mov rax rbp))
;;   (emit `(sub rax ,root)))

(let ((root (compile-tree '(1111 . ((333 . ((69 . 45) . (33 . 77))) . 2222)))))
  (emit `(mov rax rbp))
  (emit `(sub rax ,root)))

;; we have to set up a new stack frame first
;;         mov rbp,rsp

;; now build our tree structure on the stack:
;;         mov rax,102
;;         shl rax,4
;;         or rax,0b0001
;;         push rax
;;         mov rax,119
;;         shl rax,4
;;         or rax,0b0001
;;         push rax
;;         mov rax,rbp
;;         sub rax,16
;;         push rax
;;         mov rax,rbp
;;         sub rax,8
;;         shl rax,4
;;         push rax
;;         mov rax,35209
;;         shl rax,4
;;         or rax,0b0001
;;         push rax
;;         mov rax,16705
;;         shl rax,4
;;         or rax,0b0001
;;         push rax
;;         mov rax,rbp
;;         sub rax,48
;;         push rax
;;         mov rax,rbp
;;         sub rax,40
;;         shl rax,4
;;         push rax
;;         mov rax,rbp
;;         sub rax,64
;;         push rax
;;         mov rax,rbp
;;         sub rax,32
;;         shl rax,4
;;         push rax

;; we can break here in GDB and see what the stack looks like

;; (gdb) x/64xg $rbp-128
;; 0x7fffffffe5b8:	0x0000000000000000	0x0000000000000000
;; 0x7fffffffe5c8:	0x0000000000000000	0x0000000000000000
;; 0x7fffffffe5d8:	0x0000000000000000	0x0000000000000000
;; 0x7fffffffe5e8:	0x0007fffffffe6180	0x00007fffffffe5f8
;; 0x7fffffffe5f8:	0x0007fffffffe6100	0x00007fffffffe608
;; 0x7fffffffe608:	0x0000000000041411	0x0000000000089891
;; 0x7fffffffe618:	0x0007fffffffe6300	0x00007fffffffe628
;; 0x7fffffffe628:	0x0000000000000771	0x0000000000000661
;; 0x7fffffffe638:	0x0000000000000000	0x0000000000000001
;; 0x7fffffffe648:	0x00007fffffffe939	0x0000000000000000
;; 0x7fffffffe658:	0x00007fffffffe962	0x00007fffffffe96d
;; 0x7fffffffe668:	0x00007fffffffe9bf	0x00007fffffffe9e4

;; you can see the numbers - tagged - on the stakc

;; 0x7fffffffe608:	0x0000000000041411	0x0000000000089891
;; 0x7fffffffe628:	0x0000000000000771	0x0000000000000661

;; and you can see also find that they have been consed up
;; 0x7fffffffe5f8:	0x0007fffffffe6100	0x00007fffffffe608
;; 0x7fffffffe618:	0x0007fffffffe6300	0x00007fffffffe628

;; and finally those two cons celsl were consed up
;; 0x7fffffffe5e8:	0x0007fffffffe6180	0x00007fffffffe5f8
