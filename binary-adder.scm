(defmacro (whole-add i1 i2)
    (let add ((i1 i1) (i2 i2) (c #f))
	 (cond ((and (null? i1) (null? i2))
		(if c
		    (cons c ())
		    ()))
	       ((null? i1)
		(if c
		    (add (cons c ()) i2 #f)
		    i2))
	       ((null? i2)
		(add i2 i1 c))
	       (else
		(let ((d1 (car i1))
		      (r1 (cdr i1))
		      (d2 (car i2))
		      (r2 (cdr i2)))
		  (cond ((and (not d1) (not d2) (not c))
			 (cons #f (add r1 r2 #f)))
			((or (and d1 (not d2) (not c))
			     (and (not d1) d2 (not c))
			     (and (not d1) (not d2) c))
			 (cons #t (add r1 r2 #f)))
			((or (and d1 d2 (not c))
			     (and d1 (not d2) c)
			     (and (not d1) d2 c))
			 (cons #f (add r1 r2 #t)))
			(else
			 (cons #t (add r1 r2 #t)))))))))

(defmacro (read-binary so-far)
    (let read-binary ((so-far so-far))
	 (if (read-char?)
	     (cond ((read-char=? #\0)
		    (read-binary (cons #f so-far)))
		   ((read-char=? #\1)
		    (read-binary (cons #t so-far)))
		   (else
		    so-far))
	     so-far)))

(defmacro (write-binary i)
    (let write-binary ((i i))
	 (if (null? i)
	     #f
	     (begin
	      (write-binary (cdr i))
	      (if (car i)
		  (write-char #\1)
		  (write-char #\0))))))

(write-binary (whole-add (read-binary ()) (read-binary ()))))
