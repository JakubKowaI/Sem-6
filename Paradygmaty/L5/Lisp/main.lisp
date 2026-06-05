(defun binomial (n k)
  (cond ((or (< k 0) (> k n)) 0)
        ((or (= k 0) (= k n)) 1)
        (t (+ (binomial (1- n) k)
              (binomial (1- n) (1- k))))))

(defun next-row (row)
  (mapcar #'+ (cons 0 row) (append row (list 0))))

(defun pascal-row (n)
  (if (= n 0)
      (list 1)
      (next-row (pascal-row (1- n)))))

(defun binomial2 (n k)
  (if (or (< k 0) (> k n))
      0
      (nth k (pascal-row n))))

(defun split (lst)
  (labels ((go (xs left right)
             (cond ((endp xs) (values (nreverse left) (nreverse right)))
                   ((endp (cdr xs))
                    (values (nreverse (cons (car xs) left)) (nreverse right)))
                   (t (go (cddr xs)
                          (cons (car xs) left)
                          (cons (cadr xs) right))))))
    (go lst nil nil)))

(defun merge-sorted (a b)
  (cond ((endp a) b)
        ((endp b) a)
        ((<= (car a) (car b))
         (cons (car a) (merge-sorted (cdr a) b)))
        (t
         (cons (car b) (merge-sorted a (cdr b))))))

(defun mergesort (lst)
  (if (or (endp lst) (endp (cdr lst)))
      lst
      (multiple-value-bind (left right) (split lst)
        (merge-sorted (mergesort left) (mergesort right)))))

(defun egcd (a b)
  (if (= b 0)
      (values (abs a) (if (>= a 0) 1 -1) 0)
      (multiple-value-bind (g x1 y1) (egcd b (mod a b))
        (values g y1 (- x1 (* (floor a b) y1))))))

(defun de (a b)
  (multiple-value-bind (g x y) (egcd a b)
    (list x y g)))

(defun prime_factors (n)
  (labels ((factor (m p)
             (cond ((< m 2) nil)
                   ((> (* p p) m) (list m))
                   ((= (mod m p) 0) (cons p (factor (/ m p) p)))
                   (t (factor m (1+ p))))))
    (factor n 2)))

(defun totient (n)
  (labels ((count (k acc)
             (if (> k n)
                 acc
                 (count (1+ k) (if (= (gcd k n) 1) (1+ acc) acc)))))
    (if (<= n 0) 0 (count 1 0))))

(defun group-factors (lst)
  (labels ((go (xs current count acc)
             (cond ((endp xs)
                    (nreverse (cons (list current count) acc)))
                   ((= (car xs) current)
                    (go (cdr xs) current (1+ count) acc))
                   (t
                    (go (cdr xs) (car xs) 1 (cons (list current count) acc))))))
    (if (endp lst)
        nil
        (go (cdr lst) (car lst) 1 nil))))

(defun phi-from-groups (groups)
  (if (endp groups)
      1
      (let ((p (caar groups))
            (k (cadar groups)))
        (* (- p 1) (expt p (1- k)) (phi-from-groups (cdr groups))))))

(defun totient2 (n)
  (cond ((<= n 0) 0)
        ((= n 1) 1)
        (t (phi-from-groups (group-factors (prime_factors n))))))

(defun is-prime (n)
  (cond ((< n 2) nil)
        ((= n 2) t)
        ((evenp n) nil)
        (t (labels ((check (d)
                     (cond ((> (* d d) n) t)
                           ((= (mod n d) 0) nil)
                           (t (check (+ d 2))))))
             (check 3)))))

(defun primes (n)
  (labels ((collect (k acc)
             (if (> k n)
                 (nreverse acc)
                 (collect (1+ k) (if (is-prime k) (cons k acc) acc)))))
    (if (< n 2) nil (collect 2 nil))))
