256 constant stack-max

variable stack# 0 stack# !

: stack#@	stack# @ ;
: (stack#!)	stack#@ swap execute stack# ! ;
: stack#+	['] 1+ (stack#!) ;
: stack#-	['] 1- (stack#!) ;

: stack-cells	cells 2 * ;
: stack-new	stack-max create stack-cells allot
		does> stack#@ cells 2 * + ;

stack-new stack

: stack-over?	stack#@ stack-max > ;
: stack-under?	stack#@ 0 <= ;
: stack@	stack 2@ ;
: stack!	swap stack 2! ;
: stack<	stack-over?  if ." overflow"  else stack! stack#+ then ;
: stack>	stack-under? if ." underflow" else stack#- stack@ then ;
: stack<int	false stack< ;
: stack<pair	stack< ;
