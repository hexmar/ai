(defrule R1 (days ?days) (works ?works) (test (and (or (= ?days 1) (= ?days 2)) (and (> ?works 25) (<= ?works 50)))) => (assert (time "No")) (printout t "No free time" crlf));
(defrule R2 (days ?days) (works ?works) (test (and (or (= ?days 1) (= ?days 2)) (> ?works 50))) => (assert (time "No")) (printout t "No free time" crlf));
(defrule R3 (days ?days) (works ?works) (test (and (and (>= ?days 3) (<= ?days 5)) (> ?works 50))) => (assert (time "No")) (printout t "No free time" crlf));
(defrule R4 (days ?days) (works ?works) (test (and (or (= ?days 1) (= ?days 2)) (and (> ?works 0) (<= ?works 25)))) => (assert (time "Low")) (printout t "Not much free time" crlf));
(defrule R5 (days ?days) (works ?works) (test (and (and (>= ?days 3) (<= ?days 5)) (and (> ?works 25) (<= ?works 50)))) => (assert (time "Low")) (printout t "Not much free time" crlf));
(defrule R6 (days ?days) (works ?works) (test (and (and (>= ?days 6) (<= ?days 10)) (> ?works 50))) => (assert (time "Low")) (printout t "Not much free time" crlf));
(defrule R7 (days ?days) (works ?works) (test (and (> ?days 10) (> ?works 50))) => (assert (time "Low")) (printout t "Not much free time" crlf));
(defrule R8 (works 0) => (assert (time "High")) (printout t "Much free time" crlf));
(defrule R9 (days ?days) (works ?works) (test (and (and (>= ?days 3) (<= ?days 5)) (and (> ?works 0) (<= ?works 25)))) => (assert (time "High")) (printout t "Much free time" crlf));
(defrule R10 (days ?days) (works ?works) (test (and (and (>= ?days 6) (<= ?days 10)) (and (> ?works 0) (<= ?works 25)))) => (assert (time "High")) (printout t "Much free time" crlf));
(defrule R11 (days ?days) (works ?works) (test (and (and (>= ?days 6) (<= ?days 10)) (and (> ?works 25) (<= ?works 50)))) => (assert (time "High")) (printout t "Much free time" crlf));
(defrule R12 (days ?days) (works ?works) (test (and (> ?days 10) (and (> ?works 0) (<= ?works 25)))) => (assert (time "High")) (printout t "Much free time" crlf));
(defrule R13 (days ?days) (works ?works) (test (and (> ?days 10) (and (> ?works 25) (<= ?works 50)))) => (assert (time "High")) (printout t "Much free time" crlf));
(defrule R14 (temper "cold") => (assert (weather "bad")) (printout t "It's bad weather" crlf))
(defrule R15 (temper "cool") (rain "low") => (assert (weather "bad")) (printout t "It's bad weather" crlf))
(defrule R16 (rain "high") => (assert (weather "bad")) (printout t "It's bad weather" crlf))
(defrule R17 (temper "cool") (rain "no") => (assert (weather "good")) (printout t "It's good weather" crlf));
(defrule R18 (temper "warm") (rain "no") => (assert (weather "good")) (printout t "It's good weather" crlf));
(defrule R19 (temper "warm") (rain "low") => (assert (weather "good")) (printout t "It's good weather" crlf));
(defrule R20 (temper "hot") (rain "no") => (assert (weather "good")) (printout t "It's good weather" crlf));
(defrule R21 (temper "hot") (rain "low") => (assert (weather "good")) (printout t "It's good weather" crlf));
(defrule R22 (time "No") (weather "good") => (assert (act "Do work")) (printout t "Do laboratory work" crlf));
(defrule R23 (time "No") (weather "bad") => (assert (act "Do work")) (printout t "Do laboratory work" crlf));
(defrule R24 (time "Low") (weather "good") => (assert (act "Short walk")) (printout t "Go for a short walk" crlf));
(defrule R25 (time "Low") (weather "bad") => (assert (act "Tea")) (printout t "Have a cup of tea" crlf));
(defrule R26 (time "High") (weather "good") => (assert (act "Walk")) (printout t "Go for a walk" crlf));
(defrule R27 (time "High") (weather "bad") => (assert (act "Book")) (printout t "Read book" crlf));