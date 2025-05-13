%{
#include "y.tab.h"  
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
int linecounter=0;

%}
%option noyywrap
%option yylineno



char [a-zA-Z]
digits [0-9]
constant {digits}+
string {char}+


%x C_COMMENT

%%

"/*"            { BEGIN(C_COMMENT); }
<C_COMMENT>"*/" { BEGIN(INITIAL); }
<C_COMMENT>\n   { }
<C_COMMENT>.    { }

"\n"     { yylineno++; linecounter++; printf("\nline:%d",linecounter); return NEWLINE;}
"\t"     ;
" "      ;
"\""  return QM;
"/"   return DIV;
"^"   return EXP;
"*"   return MUL;
"+"   return ADD;
"-"   return MIN;
"="   return ASSGN;
","   return COMA;
";"   return SEMI;
">"   return LLE;
"<"   return RLE;
"=="  return EQUL;
"!="  return NOTEQ;
"&&"  return AND;
"||"  return OR;
"%"   return CMNT;
"("   return LPAR;
")"   return RPAR;
"["   return LAGY;
"]"   return RAGY;


"VARS"         return VAR;
"INTEGER"      return INT;
"CHAR"         return ABC;
"BREAK"        return BRK;
"WHILE"        return WHL;
"ENDWHILE"     return EWHL;
"FOR"          return FR;
"ENDFOR"       return EFR;
"ENDIF"        return EIF;
"IF"           return LIF;
"ELSE"         return LELSE;
"ELSEIF"       return LELSELIF;
"SWITCH"       return SWTCH;
"CASE"         return CS;
"PRINT"        return PRT;
"TO"           return LTO;
"PROGRAM"      return PRGM;
"STARTMAIN"    return SMN;
"ENDMAIN"      return EMN;
"FUNCTION"     return DEF;
"ENDFUNCTION"  return EDEF;
"RETURN"       return RTRN;
"STEP"         return STP;
"COUNTER"      return CNTR;
"DEFAULT"      return DFLT;
"ENDSWITCH"    return ESWTCH;
"THEN"         return THN;
"END"          return END;
"STRUCT"       return STR;
"ENDSTRUCT"    return ENDSTR;
"TYPEDEF"      return TPDEF; 




{constant} 	{ yylval.number = atoi(yytext); return con; }
{string}    { yylval.abc = strdup(yytext); return str;}



%%

