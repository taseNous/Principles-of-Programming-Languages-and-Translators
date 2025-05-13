
%{
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
void yyerror(char *); 
extern FILE *yyin;								
extern FILE *yyout;
int yylex();	
int counter=1;
%}


%token CMNT

%token <abc>str
%token <number>con

%token QM
%token STR
%token ENDSTR
%token TPDEF
%token LELSELIF
%token EIF
%token VAR
%token INT 
%token ABC
%token BRK
%token WHL
%token EWHL
%token FR
%token EFR
%token LIF
%token LELSE
%token SWTCH
%token CS
%token PRT
%token LTO
%token PRGM
%token SMN
%token EMN
%token DEF
%token EDEF
%token RTRN
%token STP
%left LPAR '('
%right RPAR ')'
%left LAGY  '['
%right RAGY ']'
%token CNTR
%token DFLT
%token ESWTCH
%token THN
%token END
%left NEWLINE 


%type <number> expr



%union{ 
    char* abc;
    int number;
}

%token EXP
%left DIV
%left MUL
%left ADD
%left MIN
%token ASSGN
%left COMA
%token SEMI
%left LLE
%left RLE
%left EQUL
%left NOTEQ
%left AND
%left OR



%%
//output
out: code;

code: PRGM name NEWLINE struct function mainDefiniiton;

//main syntax
mainDefiniiton: SMN NEWLINE declarationstar NEWLINE prog_commands EMN
                ;

callfucntion:name LPAR parameters RPAR SEMI NEWLINE;

//struct syntax
struct:     |struct STR name NEWLINE declarationstar NEWLINE ENDSTR NEWLINE
            |struct TPDEF STR name NEWLINE declarationstar name NEWLINE ENDSTR NEWLINE
            | STR name NEWLINE declarationstar NEWLINE ENDSTR NEWLINE
            | TPDEF STR name NEWLINE declarationstar name NEWLINE ENDSTR NEWLINE
            ;
          

//function syntax
function: |DEF name LPAR parameters RPAR NEWLINE declarationstar NEWLINE prog_commands RTRN value NEWLINE EDEF NEWLINE;


declarationstar: |declaration 
                ;

parameters:     |parameters COMA str con        
                |parameters COMA str 
                |str con        
                |str            
                ;

//in commands commands syntax
prog_commands:  |prog_commands expr NEWLINE
                |prog_commands commands
                |expr NEWLINE       
                |commands
                ;
                
commands: commands commands
        |cs
        |assign
        |brk
        |comments
        |while0
        |for0
        |check1
        |check2
        |print
        |callfucntion
        ;

//case syntax
check2:SWTCH LPAR expr RPAR NEWLINE cs default ESWTCH NEWLINE ;

cs:     CS LPAR expr RPAR NEWLINE prog_commands
        ;

default: |DFLT NEWLINE prog_commands
         ;

//if syntax
check1:LIF LPAR condition RPAR THN NEWLINE prog_commands EIF NEWLINE
        |LIF LPAR condition RPAR THN NEWLINE prog_commands elseif EIF NEWLINE
        |LIF LPAR condition RPAR THN NEWLINE prog_commands elseif lelse EIF NEWLINE
        |LIF LPAR condition RPAR THN NEWLINE prog_commands lelse EIF NEWLINE
        ;

elseif: LELSELIF LPAR condition RPAR NEWLINE prog_commands;

lelse: LELSE NEWLINE prog_commands;

//for syntax
for0:FR CNTR ASSGN con  LTO  con STP expr NEWLINE prog_commands EFR NEWLINE;

//while syntax
while0: WHL LPAR condition RPAR NEWLINE prog_commands EWHL NEWLINE;


//condition syntax
condition: condition logexp condition 
        | value logexp  value 
        |value
        ;
//logical operators 
logexp: LLE     
        |RLE    
        |EQUL  
        |NOTEQ 
        |AND    
        |OR     
        ;

//break syntax
brk: BRK SEMI NEWLINE  

//print syntax
print:PRT LPAR QM value QM RPAR SEMI NEWLINE                    
        |PRT LPAR QM value QM LAGY COMA name RAGY RPAR SEMI NEWLINE     
        ;       


comments: CMNT                    //comment syntax
            | CMNT name  
            ; 

assign: name ASSGN expr SEMI NEWLINE
        |name array ASSGN expr SEMI NEWLINE//assign syntax
        ;

declaration: VAR NEWLINE variables  SEMI;  //variable declaration syntax


//variables syntax
variables:  variables variables   
            |integers 
            |characters 
            ;

characters: ABC  name   //char syntax
                |characters array
                ; 
integers: INT  name     //integer syntax
                |integers array
                ;   



value:  con      //returned value can be a constant, a string or a name
        |name   
        ;

array: LAGY  con  RAGY ; //array syntax


//expresion syntax 
expr :  expr ADD  expr             
        | expr MIN  expr           
        | expr DIV  expr        {if($3==0)yyerror("\ncan't divide with zero.");} 
        | expr MUL  expr                
        | LPAR expr RPAR       {$$=$2;}    
        | con                                  
        |name
        ;


name: |name COMA str con     //name syntax (var,var1 ...)
    |name COMA str      
    |str con    
    |str        
    ;

%%
void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}


 void outputfile()
  {
    FILE *fileptr;
  
    char inputfile[300], c;
  
    printf("Enter the filename to open \n");
    scanf("%s", inputfile);
  
    
    fileptr = fopen(inputfile, "r");
    if (fileptr == NULL)
    {
        printf("Cannot open file \n");
        exit(0);
    }
  
    // Read contents from file
    c = fgetc(fileptr);
    while (c != EOF)
    {
        printf ("%c", c);
        c = fgetc(fileptr);
    }
  
    fclose(fileptr);
}
int main ( int argc, char **argv  ) 
  {
          int flag=0;
  ++argv; --argc;
  if ( argc > 0 )
       { yyin = fopen( argv[0], "r" );
        //flag=1;
        }
  else{
        yyin = stdin;
         printf("Did not provide a input file");     
  }
  yyout = fopen ( "output", "w" );
  yyparse ();
	/*if(flag==1){
                yyin=fclose(argv);
        }  */  
        outputfile();
  return 0;
  }   

 