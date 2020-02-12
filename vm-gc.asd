;;;; vm-gc.asd

(asdf:defsystem #:vm-gc
  :description "Describe vm-gc here"
  :author "Eric Lorenzana"
  :license  "ISC"
  :version "0.0.1"
  :serial t
  :depends-on (#:cl-algebraic-data-type
               #:defclass-std)
  :components ((:file "package")
               (:file "vm-gc")))
