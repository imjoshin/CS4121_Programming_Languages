#lang racket
 
(require "semantics.rkt"
         racket/stxparam)
 
(provide greater-than
         less-than
         plus
         minus
         period
         comma
         brackets
         bang
         (rename-out [my-module-begin #%module-begin]))
 
;; The current-data and current-ptr are syntax parameters used by the
;; rest of this language.
(define-syntax-parameter current-data #f)
(define-syntax-parameter current-ptr #f)
 
;; Every module in this language will make sure that it
;; uses a fresh state.
(define-syntax-rule (my-module-begin body ...)
  (#%plain-module-begin
    (let-values ([(fresh-data fresh-ptr) (new-state)])
       (syntax-parameterize
            ([current-data
              (make-rename-transformer #'fresh-data)]
             [current-ptr
              (make-rename-transformer #'fresh-ptr)])
           body ...))))
 
(define-syntax (greater-than stx)
  (syntax-case stx ()
    [(_)
     (quasisyntax/loc stx
       (increment-ptr current-data current-ptr
                      (srcloc '#,(syntax-source stx)
                              '#,(syntax-line stx)
                              '#,(syntax-column stx)
                              '#,(syntax-position stx)
                              '#,(syntax-span stx))))]))
 
(define-syntax (less-than stx)
  (syntax-case stx ()
    [(_)
     (quasisyntax/loc stx
       (decrement-ptr current-data current-ptr
                      (srcloc '#,(syntax-source stx)
                              '#,(syntax-line stx)
                              '#,(syntax-column stx)
                              '#,(syntax-position stx)
                              '#,(syntax-span stx))))]))
 
(define-syntax-rule (plus)
  (increment-byte current-data current-ptr))
 
(define-syntax-rule (minus)
  (decrement-byte current-data current-ptr))
 
(define-syntax-rule (period)
  (write-byte-to-stdout current-data current-ptr))
 
(define-syntax-rule (comma)
  (read-byte-from-stdin current-data current-ptr))
 
(define-syntax-rule (brackets body ...)
  (loop current-data current-ptr body ...))

(define-syntax-rule (bang)
  #t
)