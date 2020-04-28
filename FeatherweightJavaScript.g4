grammar FeatherweightJavaScript;


@header { package edu.sjsu.fwjs.parser; }

// Reserved words
IF        : 'if' ;
ELSE      : 'else' ;
WHILE	  : 'while';
FUNCTION  : 'function';
VAR	  : 'var';
PRINT	  : 'print';

// Literals
INT       : [1-9][0-9]* | '0' ;
BOOL	  : 'true' | 'false';
NULL	  : 'null';
ID	  : [a-zA-Z_][a-zA-Z_0-9]*;

// Symbols
ADD		  : '+' ;
SUB		  : '-' ;
MUL      	  : '*' ;
DIV     	  : '/' ;
MOD 	 	  : '%' ;
SEPARATOR 	  : ';' ;


//comparison
GT		  : '>' ;
LT 		  : '<' ;
EQ		  : '==';
GE		  : '>=';
LE 		  : '<=';
ASGN 	  	  : '=' ;


// Whitespace and comments
NEWLINE   : '\r'? '\n' -> skip ;
WS            : [ \t]+ -> skip ; // ignore whitespace
LINE_COMMENT  : '//' ~[\n\r]* -> skip ;
BLOCK_COMMENT : '/*' .*? '*/' -> skip ;

params: '(' (ID (',' ID)* )? ')' ;
args: '(' (expr (',' expr)* )? ')' ;

// ***Paring rules ***

/** The start rule */
prog: stat+ ;

stat: expr SEPARATOR                                    # bareExpr
    | IF '(' expr ')' block ELSE block                  # ifThenElse
    | IF '(' expr ')' block                             # ifThen
    | WHILE '(' expr ')' block 				# while
    | PRINT '(' expr ')' SEPARATOR 			# print
    | SEPARATOR						# empty
    ;


expr: expr op=( MUL | DIV | MOD ) expr                  # MulDivMod
	| expr op=( ADD | SUB ) expr 			# AddSub
	| expr op=( LT | LE | GT | GE | EQ ) expr 	# Compare
	| FUNCTION params block 			# FuncDec
	| expr args 					# FuncApp
    	| BOOL 						# bool
   	| INT                                           # int
    	| NULL 						# null
	| VAR ID ASGN expr 				# VarDec
	| ID 						# VarRef
	| ID ASGN expr 					# Assign
    	| '(' expr ')'                                  # parens
    	;

block: '{' stat* '}'                                    # fullBlock
     | stat                                             # simpBlock
     ;



