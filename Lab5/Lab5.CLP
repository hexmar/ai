(defglobal 
	?*ID* = 0;
)

(deffunction Get_ID()
	(bind ?*ID* (+ ?*ID* 1))
	?*ID*
)

(deffunction W (?Mode ?Depth
	?LT ?MT ?RT 
	?LM ?MM ?RM
	?LB ?MB ?RB)
	(if (= ?Mode 0) then (bind ?res ?Depth))
	(if (= ?Mode 1) then (bind ?res (* -1 ?Depth)))
	(if (or (= ?Mode 2) (= ?Mode 3)) then
		(bind ?res ?Depth)
		(bind ?t1 0) 
		(bind ?t2 1)
		(bind ?t3 2)
		(bind ?t4 3)
		(bind ?t5 4)
		(bind ?t6 5)
		(bind ?t7 6)
		(bind ?t8 7)
		(bind ?t9 8)
		(if (= ?Mode 2) then
			(if (not (= ?t1 ?LT)) then (bind ?res (+ 1 ?res)))
			(if (not (= ?t2 ?MT)) then (bind ?res (+ 1 ?res)))
			(if (not (= ?t3 ?RT)) then (bind ?res (+ 1 ?res)))
			(if (not (= ?t4 ?LM)) then (bind ?res (+ 1 ?res)))
			(if (not (= ?t5 ?MM)) then (bind ?res (+ 1 ?res)))
			(if (not (= ?t6 ?RM)) then (bind ?res (+ 1 ?res)))
			(if (not (= ?t7 ?LB)) then (bind ?res (+ 1 ?res)))
			(if (not (= ?t8 ?MB)) then (bind ?res (+ 1 ?res)))
			(if (not (= ?t9 ?RB)) then (bind ?res (+ 1 ?res)))
		)
		(if (= ?Mode 3) then
			(bind ?cpos1 (- (member$ 1 (create$ ?LT ?MT ?RT ?LM ?MM ?RM ?LB ?MB ?RB)) 1))
			(bind ?cpos2 (- (member$ 2 (create$ ?LT ?MT ?RT ?LM ?MM ?RM ?LB ?MB ?RB)) 1))
			(bind ?cpos3 (- (member$ 3 (create$ ?LT ?MT ?RT ?LM ?MM ?RM ?LB ?MB ?RB)) 1))
			(bind ?cpos4 (- (member$ 4 (create$ ?LT ?MT ?RT ?LM ?MM ?RM ?LB ?MB ?RB)) 1))
			(bind ?cpos5 (- (member$ 5 (create$ ?LT ?MT ?RT ?LM ?MM ?RM ?LB ?MB ?RB)) 1))
			(bind ?cpos6 (- (member$ 6 (create$ ?LT ?MT ?RT ?LM ?MM ?RM ?LB ?MB ?RB)) 1))
			(bind ?cpos7 (- (member$ 7 (create$ ?LT ?MT ?RT ?LM ?MM ?RM ?LB ?MB ?RB)) 1))
			(bind ?cpos8 (- (member$ 8 (create$ ?LT ?MT ?RT ?LM ?MM ?RM ?LB ?MB ?RB)) 1))

			(bind ?tpos1 (- (member$ 1 (create$ ?t1 ?t2 ?t3 ?t4 ?t5 ?t6 ?t7 ?t8 ?t9)) 1))
			(bind ?tpos2 (- (member$ 2 (create$ ?t1 ?t2 ?t3 ?t4 ?t5 ?t6 ?t7 ?t8 ?t9)) 1))
			(bind ?tpos3 (- (member$ 3 (create$ ?t1 ?t2 ?t3 ?t4 ?t5 ?t6 ?t7 ?t8 ?t9)) 1))
			(bind ?tpos4 (- (member$ 4 (create$ ?t1 ?t2 ?t3 ?t4 ?t5 ?t6 ?t7 ?t8 ?t9)) 1))
			(bind ?tpos5 (- (member$ 5 (create$ ?t1 ?t2 ?t3 ?t4 ?t5 ?t6 ?t7 ?t8 ?t9)) 1))
			(bind ?tpos6 (- (member$ 6 (create$ ?t1 ?t2 ?t3 ?t4 ?t5 ?t6 ?t7 ?t8 ?t9)) 1))
			(bind ?tpos7 (- (member$ 7 (create$ ?t1 ?t2 ?t3 ?t4 ?t5 ?t6 ?t7 ?t8 ?t9)) 1))
			(bind ?tpos8 (- (member$ 8 (create$ ?t1 ?t2 ?t3 ?t4 ?t5 ?t6 ?t7 ?t8 ?t9)) 1))

			(bind ?res (+ ?res (+ (abs (- (div ?cpos1 3) (div ?tpos1 3))) (abs (- (mod ?cpos1 3) (mod ?tpos1 3))))))
			(bind ?res (+ ?res (+ (abs (- (div ?cpos2 3) (div ?tpos2 3))) (abs (- (mod ?cpos2 3) (mod ?tpos2 3))))))
			(bind ?res (+ ?res (+ (abs (- (div ?cpos3 3) (div ?tpos3 3))) (abs (- (mod ?cpos3 3) (mod ?tpos3 3))))))
			(bind ?res (+ ?res (+ (abs (- (div ?cpos4 3) (div ?tpos4 3))) (abs (- (mod ?cpos4 3) (mod ?tpos4 3))))))
			(bind ?res (+ ?res (+ (abs (- (div ?cpos5 3) (div ?tpos5 3))) (abs (- (mod ?cpos5 3) (mod ?tpos5 3))))))
			(bind ?res (+ ?res (+ (abs (- (div ?cpos6 3) (div ?tpos6 3))) (abs (- (mod ?cpos6 3) (mod ?tpos6 3))))))
			(bind ?res (+ ?res (+ (abs (- (div ?cpos7 3) (div ?tpos7 3))) (abs (- (mod ?cpos7 3) (mod ?tpos7 3))))))
			(bind ?res (+ ?res (+ (abs (- (div ?cpos8 3) (div ?tpos8 3))) (abs (- (mod ?cpos8 3) (mod ?tpos8 3))))))
		)
	)
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
		(printout t "Mode (0 - width, 1 - depth, 2 - h1, 3 - h2 (Manhattan)): ")
		(bind ?mode (read))
		(if (and (numberp ?mode) (or (= ?mode 0) (= ?mode 1) (= ?mode 2) (= ?mode 3))) then 
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
	(if (and (> ?X ?Y ) (not (= ?mode 1))) then (retract ?f))
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

(defrule PrintInfo
(declare (salience 200))
	(not (Node (Status 0|1)))
	(TimeStart ?time)
=>
	(printout t "Solution found" crlf)
	(printout t "Time: " (- (time) ?time) " sec" crlf)
)

(defrule RefreshCurrentMinimum
(declare (salience 150))
	(Mode 2|3)
	(not (solution found))
	(not (solution unknown))
	?fmin <- (CurrentMinimum (Value ?min))
	(Node (Func ?E&: (< ?E ?min)) (Status 0))
=>
	(modify ?fmin (Value ?E))
)

(defrule IncreaseCurrentMinimum
(declare (salience 50))
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
	(bind ?fcost (W ?mode (+ ?L 1)
	?LM ?MT ?RT 
	0 ?MM ?RM 
	?LB ?MB ?RB))
	(assert (Node 
	(LeftTop ?LM) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle 0) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1) 
	?MT 0 ?RT 
	?LM ?MM ?RM 
	?LB ?MB ?RB))
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
	(bind ?fcost (W ?mode (+ ?L 1) 
	0 ?LT ?RT 
	?LM ?MM ?RM 
	?LB ?MB ?RB))
	(assert (Node 
	(LeftTop 0) (MiddleTop ?LT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT ?MM ?RT 
	?LM 0 ?RM 
	?LB ?MB ?RB))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MM) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle 0) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT ?RT 0 
	?LM ?MM ?RM 
	?LB ?MB ?RB))
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
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT 0 ?MT 
	?LM ?MM ?RM 
	?LB ?MB ?RB))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop 0) (RightTop ?MT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT ?MT ?RM 
	?LM ?MM 0 
	?LB ?MB ?RB))
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
	(bind ?fcost (W ?mode (+ ?L 1) 
	0 ?MT ?RT 
	?LT ?MM ?RM 
	?LB ?MB ?RB))
	(assert (Node 
	(LeftTop 0) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LT) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT ?MT ?RT 
	?LB ?MM ?RM 
	0 ?MB ?RB))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LB) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom 0) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT ?MT ?RT 
	?MM 0 ?RM 
	?LB ?MB ?RB))
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
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT 0 ?RT 
	?LM ?MT ?RM 
	?LB ?MB ?RB))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop 0) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MT) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT ?MT ?RT 
	0 ?LM ?RM 
	?LB ?MB ?RB))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle 0) (MiddleMiddle ?LM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT ?MT ?RT 
	?LM ?MB ?RM 
	?LB 0 ?RB))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MB) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom 0) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT ?MT ?RT 
	?LM ?RM 0 
	?LB ?MB ?RB))
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
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT ?MT 0 
	?LM ?MM ?RT 
	?LB ?MB ?RB))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop 0)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RT)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT ?MT ?RT 
	?LM 0 ?MM 
	?LB ?MB ?RB))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle 0) (RightMiddle ?MM)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT ?MT ?RT 
	?LM ?MM ?RB 
	?LB ?MB 0))
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
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT ?MT ?RT 
	0 ?MM ?RM 
	?LM ?MB ?RB))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle 0) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LM) (MiddleBottom ?MB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT ?MT ?RT 
	?LM ?MM ?RM 
	?MB 0 ?RB))
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
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT ?MT ?RT 
	?LM 0 ?RM 
	?LB ?MM ?RB))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle 0) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom ?MM) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT ?MT ?RT 
	?LM ?MM ?RM 
	0 ?LB ?RB))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom 0) (MiddleBottom ?LB) (RightBottom ?RB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT ?MT ?RT 
	?LM ?MM ?RM 
	?LB ?RB 0))
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
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT ?MT ?RT 
	?LM ?MM 0 
	?LB ?MB ?RM))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle 0)
	(LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RM)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(bind ?nextID (Get_ID))
	(bind ?fcost (W ?mode (+ ?L 1) 
	?LT ?MT ?RT 
	?LM ?MM ?RM 
	?LB 0 ?MB))
	(assert (Node 
	(LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
	(LeftMiddle ?LM) (MiddleMiddle ?MM) (RightMiddle ?RM)
	(LeftBottom ?LB) (MiddleBottom 0) (RightBottom ?MB)
	(Depth (+ ?L 1)) (Parent ?ID) (Func ?fcost) (ID ?nextID)))
	
	(if (= ?mode 1) then (modify ?fmin (Value (- ?min 1 ))))
)