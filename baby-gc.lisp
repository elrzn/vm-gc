;;;; baby-gc.lisp

(in-package #:baby-gc)

(defconstant +stack-max+ 256)

(defclass/std vm-object () ())

(defclass/std vm-object-int (vm-object)
  ((value :type integer :std 0)))

(defclass/std vm-object-pair (vm-object)
  ((head tail)))

(defclass/std vm ()
  ((stack-size :type integer :std 0)
   (stack :type '(simple-vector +stack-max+)
          :std (make-array +stack-max+
                           :initial-element nil))))

(defmethod push! ((vm vm) value)
  "Pushes a value onto the VM stack."
  (assert (< (stack-size vm) +stack-max+)
      (value)
    "Stack overflow!")
  (setf (aref (stack vm) (stack-size vm)) value))

(defmethod pop! ((vm vm))
  "Removes a value from the VM stack."
  (assert (> (stack-size vm) 0)
      ()
    "Stack underflow!")
  (decf (stack-size vm))
  (aref (stack vm) (1+ (stack-size vm))))

