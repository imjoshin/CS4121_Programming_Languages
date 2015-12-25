#lang racket
(require "cminus.rkt")
(provide my-compile)

(define (compile-file source object)
  (with-output-to-file object	
    (lambda () (compile (open-input-file source)))    
    #:exists 'replace)
  )

(define (my-compile source eval)
  (make source)
  )

(current-compile my-compile)