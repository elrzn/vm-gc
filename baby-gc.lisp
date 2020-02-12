;;;; baby-gc.lisp

(in-package #:baby-gc)

(defconstant +stack-max+ 256)

(defdata vm-object
  (vm-object-integer integer)
  (vm-object-pair vm-object vm-object))

(defclass/std vm ()
  ((stack-size :type integer :std 0)
   (stack :type (vector vm-object +stack-max+)
          :std (make-array +stack-max+ :initial-element nil))))

(defmethod push! ((vm vm) (value vm-object))
  "Pushes a value onto the VM stack."
  (assert (< (stack-size vm) +stack-max+)
      (value)
    "Stack overflow!")
  (setf (aref (stack vm) (stack-size vm)) value)
  (incf (stack-size vm))
  value)

(defmethod pop! ((vm vm))
  "Removes a value from the VM stack."
  (assert (> (stack-size vm) 0)
      ()
    "Stack underflow!")
  (decf (stack-size vm))
  (let ((val (aref (stack vm) (stack-size vm))))
    (setf (aref (stack vm) (stack-size vm))
          nil)
    val))

(defun make-dummy-vm ()
  (let ((vm (make-instance 'vm)))
    (push! vm (vm-object-integer 1337))
    (push! vm (vm-object-pair
               (vm-object-integer 1)
               (vm-object-pair
                (vm-object-integer 2)
                (vm-object-integer 3))))
    vm))
