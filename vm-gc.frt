256 constant stack-max

variable stack# 0 stack# !

: stack#@	stack# @ ;
: (stack#!)	stack#@ swap execute stack# ! ;
: stack#+	['] 1+ (stack#!) ;
: stack#-	['] 1- (stack#!) ;

: stack-new	stack-max create cells allot does> stack#@ cells 2 * + ;

stack-new stack

: stack-over?	stack#@ stack-max > ;
: stack-under?	stack#@ 0 < ;
: stack@	stack 2@ ;
: stack!	stack 2! ;
: stack<	stack! stack#+ ;
: stack>	stack#- stack@ ;
: stack<int	0 stack< ;
: stack<pair	stack< ;
