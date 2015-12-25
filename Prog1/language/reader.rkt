#lang s-exp syntax/module-reader "language/language.rkt"
#:read my-read
#:read-syntax my-read-syntax
 
(require "parser.rkt")
 
(define (my-read in)
  (syntax->datum (my-read-syntax #f in)))
 
(define (my-read-syntax src in)
  (parse-expr src in))