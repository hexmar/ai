(defglobal 
	?*ID* = 0;
)

(deffunction Get_ID()
	(bind ?*ID* (+ ?*ID* 1))
	?*ID*
)

(deffunction W (?Mode ?Depth)
	(if (= ?Mode 0) then (bind ?res ?Depth))
	(if (= ?Mode 1) then (bind ?res (* -1 ?Depth)))
	?res
)

(deftemplate Node
(slot LeftTop(type NUMBER))
(slot MiddleTop(type NUMBER))
(slot RightTop(type NUMBER))
(slot LeftMiddle(type NUMBER))
(slot MiddleMiddle(type NUMBER))
(slot RightMiddle(type NUMBER))
(slot LeftBottom(type NUMBER))
(slot MiddleBottom(type NUMBER))
(slot RightBottom(type NUMBER))

(slot Depth(type NUMBER))
(slot ID(type NUMBER) (default 0))
(slot Status(type NUMBER) (default 0))

(slot Parent(type NUMBER))
(slot Func(type NUMBER)))

(deftemplate CurrentMinimum 
	(slot Value(type NUMBER))
)

(deffacts Start
(Node (LeftTop 6) (MiddleTop 2) (RightTop 8)
	(LeftMiddle 4) (MiddleMiddle 1) (RightMiddle 7)
	(LeftBottom 5) (MiddleBottom 3) (RightBottom 0)
	(Depth 0)
	(Parent 0)
	(Func 0)
	(ID (Get_ID))
)
(CurrentMinimum (Value 0))
)

(defrule GoalTest
(declare (salience 500))
	?f <- (Node 
		(LeftTop 0) (MiddleTop 1) (RightTop 2)
		(LeftMiddle 3) (MiddleMiddle 4) (RightMiddle 5)
		(LeftBottom 6) (MiddleBottom 7) (RightBottom 8)
		(Status ~2)
		(Parent ?ID))
	=>
		(modify ?f(Status 2))
)

(defrule UserInput
(declare (salience 1500))
	(initial-fact)
=>
	(bind ?incorrectData 1)
	(while (= ?incorrectData 1)
		(printout t "Mode (0 – uniform-cost, 1 – in-depth): ")
		(bind ?mode (read))
		(if (and (numberp ?mode) (or (= ?mode 0) (= ?mode 1))) then 
			(bind ?incorrectData 0)
			(assert (Mode ?mode))
		)
	)
	(assert (TimeStart (time)))
)

(defrule DeleteRepeats 
(declare (salience 1000))
	(Mode ?mode)
	
	?f <- (Node (Func ?X) (Status 0) (ID ?ID1)
	(LeftTop ?LT1) (MiddleTop ?MT1) (RightTop ?RT1) 
	(LeftMiddle ?LM1) (MiddleMiddle ?MM1) (RightMiddle ?RM1)
	(LeftBottom ?LB1) (MiddleBottom ?MB1) (RightBottom ?RB1))
	
	(Node (Func ?Y) (Status 1) (ID ?ID2)
	(LeftTop ?LT2&:(= ?LT2 ?LT1)) (MiddleTop ?MT2&:(= ?MT2 ?MT1)) (RightTop ?RT2&:(= ?RT2 ?RT1))
	(LeftMiddle ?LM2&:(= ?LM2 ?LM1)) (MiddleMiddle ?MM2&:(= ?MM2 ?MM1)) (RightMiddle ?RM2&:(= ?RM2 ?RM1))
	(LeftBottom ?LB2&:(= ?LB2 ?LB1)) (MiddleBottom ?MB2&:(= ?MB2 ?MB1)) (RightBottom ?RB2&:(= ?RB2 ?RB1)))
	 
	=> 
	(if (and (> ?X ?Y ) (= ?mode 0)) then (retract ?f))
	(if (and (< ?X ?Y ) (= ?mode 1)) then (retract ?f))
)

(defrule SelectAnswer
(declare (salience 500))
	(Node (Status 2) (Parent ?ID))
	?f <- (Node(ID ?ID) (Status ~2))
	=>
	(modify ?f(Status 2))
)

(defrule DeleteNotAnswer
(declare (salience 300))
	(solution found)
	?f <- (Node (Status ~2))
=>
	(retract ?f)
)


(defrule NoSolution
(declare (salience 200))
	(not (Node (Status 0|2)))
	(TimeStart ?time)
=>
	(assert (solution unknown))
	(printout t "Solution unknown" crlf)
	(printout t "Time: " (- (time) ?time) " sec" crlf)
	
)

(defrule HaveSolution
(declare (salience 200))
	(Node (Status 2))
=> 
	(assert (solution found))
)

(defrule PrintSolution
(declare (salience 200))
	(not (Node (Status 0|1)))
	(TimeStart ?time)
=>
	(printout t "Solution found" crlf)
	(printout t "Time: " (- (time) ?time) " sec" crlf)
)

(defrule GoToNextLevel
(declare (salience 50))
	(Mode 0|1)
	(not (solution found))
	(not (solution unknown))
	?fmin <- (CurrentMinimum (Value ?min))
=>
	(modify ?fmin (Value (+ 1 ?min)))
)

(defrule NewPathLT
(declare (salience 100))
(Mode ?mode)
?fmin <- (CurrentMinimum (Value ?min))
?f <- (Node (Status 0) (Depth ?L) (ID ?ID)
	(LeftTop 0) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Func ?E& : (= ?E ?min)))
=>
	(modify ?f (Status 1))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LM) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle 0) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?MT) (MiddleTop 0) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(if (= ?mode 1) then (modify ?fmin (Value (- ?min 1 ))))
)

(defrule NewPathMT
(declare (salience 100))
(Mode ?mode)
?fmin <- (CurrentMinimum (Value ?min))
?f <- (Node (Status 0) (Depth ?L) (ID ?ID)
	(LeftTop ?LT) (MiddleTop 0) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Func ?E& : (= ?E ?min)))
=>
	(modify ?f (Status 1))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop 0) (MiddleTop ?LT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MM) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle 0) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?RT) (RightTop 0)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(if (= ?mode 1) then (modify ?fmin (Value (- ?min 1 ))))
)

(defrule NewPathRT
(declare (salience 100))
(Mode ?mode)
?fmin <- (CurrentMinimum (Value ?min))
?f <- (Node (Status 0) (Depth ?L) (ID ?ID)
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop 0)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Func ?E& : (= ?E ?min)))
=>
	(modify ?f (Status 1))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop 0) (RightTop ?MT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RM)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle 0)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(if (= ?mode 1) then (modify ?fmin (Value (- ?min 1 ))))
)

(defrule NewPathLM
(declare (salience 100))
(Mode ?mode)
?fmin <- (CurrentMinimum (Value ?min))
?f <- (Node (Status 0) (Depth ?L) (ID ?ID)
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle 0) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Func ?E& : (= ?E ?min)))
=>
	(modify ?f (Status 1))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop 0) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LT) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LB) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom 0) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?MM) (MiddleMiddle 0) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(if (= ?mode 1) then (modify ?fmin (Value (- ?min 1 ))))
)

(defrule NewPathMM
(declare (salience 100))
(Mode ?mode)
?fmin <- (CurrentMinimum (Value ?min))
?f <- (Node (Status 0) (Depth ?L) (ID ?ID)
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle 0) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Func ?E& : (= ?E ?min)))
=>
	(modify ?f (Status 1))

	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop 0) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MT) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle 0) (MiddleMiddle ?LM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MB) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom 0) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?RM) (RightMiddle 0)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(if (= ?mode 1) then (modify ?fmin (Value (- ?min 1 ))))
)

(defrule NewPathRM
(declare (salience 100))
(Mode ?mode)
?fmin <- (CurrentMinimum (Value ?min))
?f <- (Node (Status 0) (Depth ?L) (ID ?ID)
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle 0)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Func ?E& : (= ?E ?min)))
=>
	(modify ?f (Status 1))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop 0)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RT)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle 0) (RightMiddle ?MM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RB)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom 0)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(if (= ?mode 1) then (modify ?fmin (Value (- ?min 1 ))))
)

(defrule NewPathLB
(declare (salience 100))
(Mode ?mode)
?fmin <- (CurrentMinimum (Value ?min))
?f <- (Node (Status 0) (Depth ?L) (ID ?ID)
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom 0) (MiddleBottom ?MB) (RightBottom ?RB)
	(Func ?E& : (= ?E ?min)))
=>
	(modify ?f (Status 1))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle 0) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LM) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?MB) (MiddleBottom 0) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(if (= ?mode 1) then (modify ?fmin (Value (- ?min 1 ))))
)

(defrule NewPathMB
(declare (salience 100))
(Mode ?mode)
?fmin <- (CurrentMinimum (Value ?min))
?f <- (Node (Status 0) (Depth ?L) (ID ?ID)
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom 0) (RightBottom ?RB)
	(Func ?E& : (= ?E ?min)))
=>
	(modify ?f (Status 1))

	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle 0) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MM) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom 0) (MiddleBottom ?LB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?RB) (RightBottom 0)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(if (= ?mode 1) then (modify ?fmin (Value (- ?min 1 ))))
)

(defrule NewPathRB
(declare (salience 100))
(Mode ?mode)
?fmin <- (CurrentMinimum (Value ?min))
?f <- (Node (Status 0) (Depth ?L) (ID ?ID)
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom 0)
	(Func ?E& : (= ?E ?min)))
=>
	(modify ?f (Status 1))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle 0)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RM)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1)))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom 0) (RightBottom ?MB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(if (= ?mode 1) then (modify ?fmin (Value (- ?min 1 ))))
)