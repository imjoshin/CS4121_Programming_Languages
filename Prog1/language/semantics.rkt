#lang racket
 
(provide (all-defined-out))
 
;; We use a customized error structure that supports
;; source location reporting.
(define-struct (exn:fail:out-of-bounds exn:fail)
  (srcloc)
  #:property prop:exn:srclocs
             (lambda (a-struct)
               (list (exn:fail:out-of-bounds-srcloc a-struct))))
 
;; Provides two values: a byte array of 30000 zeros, and
;; the pointer at index 0.
(define-syntax-rule (new-state)
  (values (make-vector 30000 0)
          0))
 
;; increment the data pointer
(define-syntax-rule (increment-ptr data ptr loc)
  (begin
    (set! ptr (add1 ptr))
    (when (>= ptr (vector-length data))
      (raise (make-exn:fail:out-of-bounds
              "out of bounds"
              (current-continuation-marks)
              loc)))))
 
;; decrement the data pointer
(define-syntax-rule (decrement-ptr data ptr loc)
  (begin
    (set! ptr (sub1 ptr))
    (when (< ptr 0)
      (raise (make-exn:fail:out-of-bounds
              "out of bounds"
              (current-continuation-marks)
              loc)))))
 
;; increment the byte at the data pointer
(define-syntax-rule (increment-byte data ptr)
  (vector-set! data ptr
               (modulo (add1 (vector-ref data ptr)) 256)))
 
;; decrement the byte at the data pointer
(define-syntax-rule (decrement-byte data ptr)
  (vector-set! data ptr
               (modulo (sub1 (vector-ref data ptr)) 256)))
 
;; print the byte at the data pointer
(define-syntax-rule (write-byte-to-stdout data ptr)
  (write-byte (vector-ref data ptr) (current-output-port)))

;; read a byte from stdin into the data pointer
(define-syntax-rule (read-byte-from-stdin data ptr)
  (vector-set! data ptr
               (let ([a-value (read-byte (current-input-port))])
                 (if (eof-object? a-value)
                     0
                     a-value))))
 
;; we know how to do loops!
(define-syntax-rule (loop data ptr body ...)
  (let loop ()
    (unless (= (vector-ref data ptr)
               0)
      body ...
      (loop))))