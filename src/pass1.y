%{
#include "includefile.h"
extern FILE *yyin;
extern int locctr;
int lineno=1;
FILE *op;
char hex[5];
int flag = 0;
%}

%union {
  int val;
  char str[40];
}

%token OP_ZERO OP_ONE OP_TWO END
%token REG8 REG16 BCONST WCONST
%token MEMORY DB DW NL STR LABEL 

%nonassoc CON
%nonassoc ','


%type <str> OP_ZERO
%type <str> OP_ONE
%type <str> OP_TWO
%type <str> LABEL
%type <str> REG16
%type <str> REG8
%type <str> REG
%type <str> MEMORY
%type <str> STR
%type <val> VAL
%type <val> VAR
%type <val> INSTR
%type <val> WLIST
%type <val> BLIST
%type <str> WCONST
%type <str> BCONST
%type <val> REGMEM
%type <val> IMMEDIATE
%type <val> CONST
%type <val> RM
%type <val> MEM
%type <val> ZERO_ARG
%type <val> ONE_ARG
%type <val> TWO_ARG
%%

PROG: Stat {flag = 0;};

Stat: NS {lineno++;} Stat
|
| error NL {lineno++;flush_string();} Stat
NS: VAR NL
| INSTR {make_instruction(); } NL {locctr+=$1;}
| LABEL INSTR NL {
		Symbol *sym = search_symbol($1);
		if(sym==NULL){
		  insert_symbol($1,locctr,0);
		  locctr+=$2;
		  make_instruction();
		  }
		 else if(sym ->addrs == -1){
		  sym->addrs = locctr;
		  resolve_links(sym);
		  locctr+=$2;
		  make_instruction();
		  }
		 else
		 {
		 	flush_string();
			noOfInstructions++;
		 	printf("Error Same label found! at line no. %d\n", lineno);
		 	
		 }
		}
| NL
| END {return;}

VAR: LABEL VAL  {
	
		$$ = $2;
		Symbol *sym = search_symbol($1);
		if(sym==NULL)
		  insert_symbol($1,locctr,0);
		 else if(sym ->addrs == -1)
		 {
		  sym->addrs = locctr;
		  resolve_links(sym);
		 }
		 else
		 {
		 	
		 	printf("Error: Same label found! at line no. %d\n", lineno);
		 	
		 }
		 locctr+=$2;
		}

VAL: DW WLIST   {$$=$2;}
| DB BLIST      {$$=$2;}
| DB STR        {$$=strlen($2)-2;}

WLIST: WCONST ',' WLIST {$$=2+$3;}
| WCONST 		{$$=2;}

BLIST: BCONST ',' BLIST {$$=1+$3;}
| BCONST 		{$$=1;}

INSTR: ZERO_ARG	{$$=$1;}
| ONE_ARG	{$$=$1;}
| TWO_ARG	{$$=$1;}

ZERO_ARG : OP_ZERO {$$ = 1; strcpy(opcode, $1);}
ONE_ARG : OP_ONE RM {$$ = 1 + $2; strcpy(opcode, $1); }
TWO_ARG : OP_TWO IMMEDIATE {$$ = 1 + $2; strcpy(opcode, $1); }
	| OP_TWO REGMEM {$$ = 1 + $2; strcpy(opcode, $1); }


REGMEM: REG ',' MEM  	{$$=$3; strcpy(reg, $1); strcpy(mode, "00");}
| REG ',' REG 	     	{$$=0; strcpy(reg, $1); strcpy(rm, $3); strcpy(mode, "11");}


IMMEDIATE: RM ',' CONST {$$=$1+$3;}

RM: REG	 %prec CON	{$$=0; strcpy(rm, $1); arg = 1; strcpy(mode, "11");}
| MEM	 %prec CON	{$$=$1; arg = 1; strcpy(mode, "00");}


MEM: MEMORY		{$$=0; strcpy(rm, $1);}
| '[' CONST ']'		{$$=$2; strcpy(rm, "INDIRECT");}
| CONST			{$$=$1; strcpy(rm, "DIRECT");}
| LABEL	 		{
			 $$ = 1;
			 strcpy(rm, "LABEL");
			 strcpy(addr, $1);
			}

CONST: WCONST	{$$=2;  strcpy(addr, $1);}
| BCONST     	{$$=1;  strcpy(addr, $1);}

REG: REG8 {strcpy($$, $1);}
| REG16 {strcpy($$, $1);}
;
%%

int main(int argc, char *argv[])
{
  head = NULL;
  flush_string();
  load_opfile();
  locctr=0;
  yyin=fopen(argv[1],"r");
  if(!yyin) printf("Input file not found");
  yyparse();
  
  if(flag)
  	final_errors(); 
  
  else
  {
  print_symtab();
  print_object();
  write_symtab();
  write_object();
  }
  printf("\n");
  return 0;

}


void yyerror(char *s)
{
  flag = 1;
  printf("\nError: %d : %s\n",lineno, s); 
}
