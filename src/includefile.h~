#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int check_status = 0;
char s[32];
char object_code[100000][32];
int noOfInstructions = 0;
extern int lineno;


char opcode[7], d[2], w[2], mode[3], reg[4], rm[15], addr[17];
int op1_type, op2_type, arg;
char bin_hex[16][5] = {"0000","0001","0010","0011","0100","0101","0110","0111","1000","1001","1010","1011","1100","1101","1110","1111"};

int n = 0;


struct symbol
{
	int noOfLinks;
	int link_addr[100];
	int used;
	char label[25];
	int addrs;
	struct symbol *link;
};

struct optable_type
{
	char op[15];
	char op_code[8];
}optable[100];


typedef struct symbol Symbol;

Symbol *head = NULL;

void tohex(unsigned int num,char hex[],int len)
{
	int i,j=len-1;
	while(j>=0)
	{
		i=num%16;
		num/=16;
		hex[j--]=((i<10)? ('0'+i):('A'+i-10));
	}
  	hex[len]='\0';
}


Symbol *search_symbol(char label[])
{
	if(head == NULL)
  		return NULL;
  
	Symbol *cur = head;
	while(cur&&strcmp(cur->label,label)!=0)
   		cur=cur->link;
  	
  	return cur;
}

void insert_symbol(char label[],int addrs, int used)
{
	Symbol *temp;
  	temp=(Symbol *)malloc(sizeof(Symbol));
  	strcpy(temp->label,label);
  	temp->addrs=addrs;
  	temp->noOfLinks = 0;
  	temp->link=head;
  	temp->used = used;
  	head = temp;
}

void final_errors()
{
	Symbol *cur;
  	char hex[5];
  	int c=0; 
    	cur=head;
    	while(cur) { 
      		if(cur->addrs == -1)
      		{
      			printf("Error: Label not found! : %s\n", cur->label);
      		}
      		if(cur->used == 0)
      		{
      			printf("Warning: Label not used! : %s\n", cur->label);
      		}
      		cur=cur->link;
    
  	}

}

void print_symtab()
{
	Symbol *cur;
  	char hex[5];
  	int c=0;
  	printf("\nSymtab\n"); 
    	cur=head;
    	while(cur) { 
      		if(cur->addrs == -1)
      		{
      			cur=cur->link;
        		continue;
      		}
      		tohex(cur->addrs,hex,4);
      		printf("%s %s\n",cur->label,hex);
      		cur=cur->link;
    
  	}
}


void write_symtab()
{
	FILE *sym;
  	int i;
	sym=fopen("symtab.txt","w");
  	Symbol *cur;
  	char hex[5];
 
    	cur=head;
    	while(cur!=NULL)
    	{
    		tohex(cur->addrs,hex,4);
      		fprintf(sym,"%s %s\n",cur->label,hex);
      		cur=cur->link;
    	}
  
  	fclose(sym);
}

void write_object()
{
	FILE *fp = fopen("assembly_code.obj", "w");
	int i;
	for(i = 0; i < noOfInstructions; i++)
	{
		fprintf(fp,"%s\n", object_code[i]);
	}
}

void print_object()
{
	int i;
	printf("\n\n\nObject Code: \n");
	for(i = 0; i < noOfInstructions; i++)
	{
		printf("%s\n", object_code[i]);
	}
}

void load_opfile()
{
	int i = 0;
	FILE *fp = fopen("newoptable.txt", "r");
	
	if(!fp)
	{
		printf("Optable doesn't exist!!!");
		exit(0);
	}
	
	while(fscanf(fp, "%s%s", optable[i].op, optable[i].op_code) > 0)
	{	
		i++;
	}
	
	n = i;
	
}


void initialize()
{
	int i;
	noOfInstructions = 0;
	for(i = 0; i < 1000; i++)
	{
		strcpy(object_code[i], "\0");
	}
}


void flush_string()
{
	op1_type = -1;
	op2_type = -1;
	arg = -1;
	strcpy(s, "\0");
	strcpy(opcode, "\0");
	strcpy(d, "\0");
	strcpy(w, "\0");
	strcpy(reg, "\0");
	strcpy(w, "\0");
	strcpy(mode, "\0");
	strcpy(addr, "\0");
	strcpy(rm, "\0");
}



void first_to_hex()
{
	int i = 0, j;
	char p[5], hex_val[2];
	hex_val[1] = '\0';
	
	while(i < 16)
	{
		for(j = 0; j < 4; j++)
			p[j] = s[i + j];
		p[j] = '\0'; 
		for(j = 0; j < 16; j++)
		{
			if(!strcmp(bin_hex[j], p))
			{
				if(j < 10){
					hex_val[0] = j + 48;
					strcat(object_code[noOfInstructions], hex_val);
				}
				
				else
				{
					hex_val[0] = j + 55;
					strcat(object_code[noOfInstructions], hex_val);
				}
			}
		}
		
		i += 4;
	}
	
	for(i = 16; i < strlen(s); i++)
		p[i - 16] = s[i];
	p[i - 16] = '\0';
	strcat(object_code[noOfInstructions], p);
	noOfInstructions++;
	flush_string();
}





void hex_to_binary_opcode(char hex[10])
{
	int i;
	for(i = 0; hex[i] != '\0'; i++)
	{
		if(i == 0){
		if(hex[i] == '0')
			strcat(s, "0000");
		else if(hex[i] == '1')
			strcat(s, "0001");
		else if(hex[i] == '2')
			strcat(s, "0010");
		else if(hex[i] == '3')
			strcat(s, "0011");
		else if(hex[i] == '4')
			strcat(s, "0100");
		else if(hex[i] == '5')
			strcat(s, "0101");
		else if(hex[i] == '6')
			strcat(s, "0110");
		else if(hex[i] == '7')
			strcat(s, "0111");
		else if(hex[i] == '8')
			strcat(s, "1000");
		else if(hex[i] == '9')
			strcat(s,  "1001");
		else if(hex[i] == 'A')
			strcat(s,  "1010");
		else if(hex[i] == 'B')
			strcat(s, "1011");
		else if(hex[i] == 'C')
			strcat(s, "1100");
		else if(hex[i] == 'D')
			strcat(s, "1101");
		else if(hex[i] == 'E')
			strcat(s, "1110");
		else if(hex[i] == 'F')
			strcat(s, "1111");
		else{
			printf("Wrong opcode!");
			exit(1);
		}
		}
		
		else
		{
		if(hex[i] == '0')
			strcat(s, "00");
		else if(hex[i] == '1')
			strcat(s, "01");
		else if(hex[i] == '2')
			strcat(s, "10");
		else if(hex[i] == '3')
			strcat(s, "11");
		else if(hex[i] == '4')
			strcat(s, "00");
		else if(hex[i] == '5')
			strcat(s, "01");
		else if(hex[i] == '6')
			strcat(s, "10");
		else if(hex[i] == '7')
			strcat(s, "11");
		else if(hex[i] == '8')
			strcat(s, "00");
		else if(hex[i] == '9')
			strcat(s,  "01");
		else if(hex[i] == 'A')
			strcat(s,  "10");
		else if(hex[i] == 'B')
			strcat(s, "11");
		else if(hex[i] == 'C')
			strcat(s, "00");
		else if(hex[i] == 'D')
			strcat(s, "01");
		else if(hex[i] == 'E')
			strcat(s, "10");
		else if(hex[i] == 'F')
			strcat(s, "11");
		else
		{
			printf("Wrong Opcode!");
			exit(0);
		}
		}
	}
}



void reverse(char bin[8])
{
	int i;
	char temp;
	for(i = 0; i < 4; i++)
	{
		temp = bin[i];
		bin[i] = bin[7-i];
		bin[7-i] = temp;
	}
}
		
void decimal_to_hex(int dec, char a[3])
{
	int i = 0, m;
	char temp;
	while(dec > 0)
	{
		m = (dec % 16);
		if(m < 10)
			a[i++] = m + '0';
		else
			a[i++] = m + 55;
			
		dec /= 16;
	} 
	
	
	if(dec == 0)
	{
		a[0] = '0';
		a[1] = '0';
	}
	
	else if(i == 1)
		a[1] = '0';
		
	temp = a[0];
	a[0] = a[1];
	a[1] = temp;
	a[2] = '\0';
}

void resolve_links(Symbol *temp)
{
	int i;
	char a[2];
	decimal_to_hex(temp->addrs, a);
	for(i = 0; i < temp->noOfLinks; i++)
	{	
		strcat(object_code[temp->link_addr[i]], a);	
	}
	
	temp->noOfLinks = 0;
}



void make_instruction()
{
	//printf("opcode %s\nmode %s\nreg %s\nrm %s\naddr %s", opcode, mode, reg, rm, addr);
	if(!strcmp(reg, "AL") || !strcmp(reg, "BL") || !strcmp(reg, "CL") || !strcmp(reg, "DL") || !strcmp(reg, "AH") ||!strcmp(reg, "BH") ||!strcmp(reg, "CH") ||!strcmp(reg, "DH") ){
		op1_type = 0;
	}
	
	else
	{
		op1_type = 1;
	}
	
	
	if(!strcmp(rm, "AL") || !strcmp(rm, "BL") || !strcmp(rm, "CL") || !strcmp(rm, "DL") || !strcmp(rm, "AH") ||!strcmp(rm, "BH") ||!strcmp(rm, "CH") ||!strcmp(rm, "DH") )
	{
		op2_type = 0;
	}
	
	else
	{
		op2_type = 1;
	}
	
	
	if(op1_type != op2_type)
	{
		printf("Error: %d : Parameters are of different sizes\n", lineno);
		noOfInstructions++;
		flush_string();
		return;
	}
	
	
	
	
	int i, j;
	
	for(i = 0; i < n; i++)
	{
		if(!strcmp(opcode, optable[i].op))
			break;
	}
	
	hex_to_binary_opcode(optable[i].op_code);

	strcat(s, "0");
	
	// if instruction is of only one byte	
	if(!strcmp(mode,"\0"))
	{
		strcat(s,"0");
		char p[5], hex_val[2];
		hex_val[1] = '\0';
		for(j = 0; j < 4; j++)
			p[j] = s[j];
		
		p[4] = '\0';
		for(j = 0; j < 16; j++)
		{
			if(!strcmp(bin_hex[j], p))
			{
				if(j < 10){
					hex_val[0] = j + 48;
					strcat(object_code[noOfInstructions], hex_val);
				}
				
				else
				{
					hex_val[0] = j + 55;
					strcat(object_code[noOfInstructions], hex_val);
				}
			}
		}
		
		
		for(j = 4; j < 8; j++)
			p[j - 4] = s[j];
		
		p[4] = '\0';
		for(j = 0; j < 16; j++)
		{
			if(!strcmp(bin_hex[j], p))
			{
				if(j < 10){
					hex_val[0] = j + 48;
					strcat(object_code[noOfInstructions], hex_val);
				}
				
				else
				{
					hex_val[0] = j + 55;
					strcat(object_code[noOfInstructions], hex_val);
				}
			}
		}
	
		noOfInstructions++;
		flush_string();
		return;
	}	
	
	//for w
	if(op1_type == 1)
		strcat(s, "1");
	else
		strcat(s, "0");
	
	
	strcat(s, mode); // for mode
	
	
	if(!strcmp(rm, "DIRECT"))
		strcat(s,"000");
	
	// for reg
	if(!strcmp(reg, "AL") || !strcmp(reg, "AX"))
		strcat(s,"000");
	else if(!strcmp(reg, "BL") || !strcmp(reg, "BX"))
		strcat(s,"011");
	else if(!strcmp(reg, "CL") || !strcmp(reg, "CX"))
		strcat(s,"001");
	else if(!strcmp(reg, "DL") || !strcmp(reg, "DX"))
		strcat(s,"010");
	else if(!strcmp(reg, "AH") || !strcmp(reg, "SP"))
		strcat(s,"100");
	else if(!strcmp(reg, "CH") || !strcmp(reg, "BP"))
		strcat(s,"101");
	else if(!strcmp(reg, "DH") || !strcmp(reg, "SI"))
		strcat(s,"110");
	else if(!strcmp(reg, "DI") || !strcmp(reg, "BH"))
		strcat(s,"111");
	else
		strcat(s,"000");
		
	// for rm
	if(!strcmp(rm, "INDIRECT") || !strcmp(rm, "LABEL"))
		strcat(s,"110");
	else if(!strcmp(rm, "DIRECT"));
	else if(!strcmp(rm, "AL") || !strcmp(rm, "AX"))
		strcat(s,"000");
	else if(!strcmp(rm, "BL") || !strcmp(rm, "BX"))
		strcat(s,"011");
	else if(!strcmp(rm, "CL") || !strcmp(rm, "CX"))
		strcat(s,"001");
	else if(!strcmp(rm, "DL") || !strcmp(rm, "DX"))
		strcat(s,"010");
	else if(!strcmp(rm, "AH") || !strcmp(rm, "SP"))
		strcat(s,"100");
	else if(!strcmp(rm, "CH") || !strcmp(rm, "BP"))
		strcat(s,"101");
	else if(!strcmp(rm, "DH") || !strcmp(rm, "SI"))
		strcat(s,"110");
	else if(!strcmp(rm, "DI") || !strcmp(rm, "BH"))
		strcat(s,"111");
	else if(!strcmp(rm, "[BX+SI]"))
		strcat(s, "000");
	else if(!strcmp(rm, "[BX+DI]"))
		strcat(s, "001");
	else if(!strcmp(rm, "[BP+SI]"))
		strcat(s, "010");
	else if(!strcmp(rm, "[BP+DI]"))
		strcat(s, "011");
	else if(!strcmp(rm, "[SI]"))
		strcat(s, "100");
	else if(!strcmp(rm, "[DI]"))
		strcat(s, "101");
	else if(!strcmp(rm, "[BX]"))
		strcat(s, "111");


	Symbol *sym;
	char a[3];
	
	if(!strcmp(rm, "DIRECT"))
	{
		strcat(s,addr);
		s[strlen(s) - 1] = '\0';
	}
	
	else if(!strcmp(rm, "LABEL"))
	{
		sym = search_symbol(addr);
		if(sym == NULL)
		{
			insert_symbol(addr, -1, 1);
			sym = search_symbol(addr);
			sym->link_addr[sym->noOfLinks++] = noOfInstructions;
			
		}
		else if(sym->addrs != -1)
		{
			sym->used = 1;
			decimal_to_hex(sym->addrs, a);

			strcat(s, a);
			
			
		}
		
		else
		{
			sym->used = 1;
			sym -> link_addr[sym->noOfLinks++] = noOfInstructions;
		}
		 	
	}

	//Converting first 8 bits to hex
	first_to_hex();	
}


	
