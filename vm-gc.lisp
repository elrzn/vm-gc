;;;; vm-gc.lisp

(in-package #:vm-gc)

(defconstant +stack-max+ 256)

(defclass/std vm-object ()
  ((markedp :type boolean :std nil)
   (next-object :type vm-object)))

(defclass/std vm-object-integer (vm-object)
  ((value :type integer :std 0)))

(defclass/std vm-object-pair (vm-object)
  ((head :type vm-object)
   (tail :type vm-object)))

(defclass/std vm ()
  ((stack-size :type integer :std 0)
   (stack :type (vector vm-object +stack-max+)
          :std (make-array +stack-max+ :initial-element nil))
   (first-object :type vm-object)))

(defmethod push! ((vm vm) (value vm-object))
  "Pushes a value onto the VM stack."
  (assert (< (stack-size vm) +stack-max+)
      (value)
    "Stack overflow!")
  (setf (next-object value) (first-object vm))
  (setf (first-object vm) value)
  (setf (aref (stack vm) (stack-size vm)) value)
  (incf (stack-size vm))
  value)

(defmethod push! ((vm vm) (value integer))
  (push! vm (make-instance 'vm-object-integer :value value)))

(defmethod push-integer! ((vm vm) (value integer))
  (push! vm value))

(defmethod push-pair! ((vm vm))
  (let ((pair (make-instance 'vm-object-pair)))
    (setf (tail pair) (pop! vm))
    (setf (head pair) (pop! vm))
    (push! vm pair)))

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

(defmethod mark (object) nil)

(defmethod mark ((vm vm))
  (loop for object
        across (stack vm)
        do (mark object)))

(defmethod mark ((object vm-object))
  (when (not (markedp object))
    (setf (markedp object) t)))

(defmethod mark ((object vm-object-pair))
  (when (not (markedp object))
    (mark (head object))
    (mark (tail object))
    (call-next-method)))

(defmethod sweep ((vm vm))
  (loop with object = (first-object vm)
        while object
        if (markedp object)
        do (progn
             (setf (markedp object) nil)
             (setf object (next object)))
        else do (let ((unreached object))
                  (setf object (next unreached))
                  (makunbound unreached))))
