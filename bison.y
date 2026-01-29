%{
#include <stdio.h>
int yylex(void);
void yyerror (const char *s)
{
}    
%}


%token tPLUS tMINUS tMUL tEXP tLPR tRPR tASSIGN tCOMMA tSEMICOLON tDERIVATION tINTEGRATION tCALCULATE tIDENTIFIER tINTEGER
%right tEXP
%left tMUL T_IMPLICIT
%left tPLUS tMINUS


%%

program:
    definition_block calculation_block;

definition_block:
    def_list;

def_list:
    
    | def_list function_def;

function_def:
    tIDENTIFIER function_paranthesis tASSIGN ordinary_exp tSEMICOLON;

function_paranthesis:
    tLPR tRPR |
    tLPR tIDENTIFIER tRPR |
    tLPR tIDENTIFIER comma_variable tRPR;

comma_variable:
    tCOMMA tIDENTIFIER |
    comma_variable tCOMMA tIDENTIFIER;

calculation_block:
    calc_list;

calc_list:
    
    | calc_list calculation_statement;

calculation_statement:
    tCALCULATE extended_expr tSEMICOLON;

ordinary_exp:
    ordinary_exp tPLUS ord_term |
    ordinary_exp tMINUS ord_term |
    ord_term;

ord_term:
    ord_term tMUL ord_factor |
    ord_term ord_factor %prec T_IMPLICIT |
    ord_factor;

ord_factor:
    tLPR ordinary_exp tRPR |
    ord_power |
    tINTEGER |
    tIDENTIFIER;

ord_power:
    tINTEGER tEXP tINTEGER |
    tIDENTIFIER tEXP tINTEGER;

extended_expr:
    extended_expr tPLUS ext_term |
    extended_expr tMINUS ext_term |
    ext_term;

ext_term:
    ext_term tMUL ext_factor |
    ext_term ext_factor %prec T_IMPLICIT |
    ext_factor;

ext_factor:
    tLPR extended_expr tRPR |
    tLPR tRPR |
    comma_sep_list |
    ext_power |
    tINTEGER |
    tIDENTIFIER |
    integration |
    derivation;

comma_sep_list:
    tLPR extended_expr tCOMMA extended_expr comma_list_tail tRPR;

comma_list_tail:
     
     |comma_tail;

comma_tail:
    tCOMMA extended_expr |
    comma_tail tCOMMA extended_expr;

ext_power:
    tINTEGER tEXP tINTEGER |
    tIDENTIFIER tEXP tINTEGER;










integration:
    tINTEGRATION tLPR tIDENTIFIER tCOMMA tIDENTIFIER tCOMMA tINTEGER tRPR;

derivation:
    tDERIVATION tLPR tIDENTIFIER tCOMMA tIDENTIFIER tCOMMA tINTEGER tRPR;



%%

int main ()
{
if (yyparse())
{
// parse error
printf("ERROR\n");
return 1;
}
else
{
// successful parsing
printf("OK\n");
return 0;
}
}
