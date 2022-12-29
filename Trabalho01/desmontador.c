#include <fcntl.h>
#include <unistd.h>

struct initialInfos{
    int e_shoff;
    int e_shnum;
    int e_shstrndx;
    int sh_offset;
    int sh_offsetSymtab;
    int sh_offsetStrtab;
    int sizeSymtab;
    int sh_offsetText;
    int sizeText;
    int vmaText;
    int sectionTable[50000];   
    int sizeSTVec;
}; 
typedef struct initialInfos inicialInfos;

void readFile(char *argv[], unsigned char file[100000]){
    int fd = open(argv[2], O_RDONLY);
    read(fd, file, 100000);
    close(fd);
}

int elevated(int digit, int index, int base){
  //Retorna digit vezes o a base elevada ao index
  int aux = digit;
  for(int i=0;i < index;i++){
    aux = aux*base;
  }
  return aux;
}

int strLen(unsigned char file[100000], int index){
    int i;
    for(i=index;file[i] != '\0';i++){}; 
    return i-index; 
}

int strLenSigned(char *file, int index){
    int i;
    for(i=index;file[i] != '\0';i++){}; 
    return i-index; 
}

int getAdress(unsigned char file[100000], int pos){
    int aux=0;
    for(int i=0;i<4;i++){
        aux += elevated(file[pos+i], i, 1<<8); 
    }
    return aux;
}

char changeToLet(int aux){  
    if(aux == 10) return 'a';
    if(aux == 11) return 'b';
    if(aux == 12) return 'c';
    if(aux == 13) return 'd';
    if(aux == 14) return 'e';
    if(aux == 15) return 'f';
    else return aux + '0';
}

void getString(int toConvert, int base, char converted[9]){
    int aux = 7;
    unsigned int total = toConvert;
    while(total > 0 && aux > -1){
        converted[aux] = changeToLet(total%base);
        total = total/base;
        aux--;
    }
    for(int i=0;i<=aux;i++){
        converted[i] = '0';
    }
    converted[8] = '\0';    
}

void getStringInst(int toConvert, char converted[9]){
    char aux[8];

    getString(toConvert, 16, converted);
    aux[0] = converted[6]; 
    aux[1] = converted[7]; 
    aux[2] = converted[4]; 
    aux[3] = converted[5]; 
    aux[4] = converted[2]; 
    aux[5] = converted[3]; 
    aux[6] = converted[0]; 
    aux[7] = converted[1];
    for(int i=0;i<7;i+=2){
        write(1, &aux[i], 1);
        write(1, &aux[i+1], 1);
        write(1, " ", 1);
    }
}

void addMinus(char toAdd[20]){
    char aux[20];
    
    for(int i=0;i<8;i++){
        aux[i] = toAdd[i];
    }
    toAdd[0] = '-';
    for(int j=0;j<8;j++){
        toAdd[j+1] = aux[j];
    }
}

int cutZeros(char toTruncate[8]){
    int cont = 0;
    int i;
    char aux[8];
    for(i=0;toTruncate[i] == '0' && i<8;i++);
    int var = i;
    for(int j=0;j<8-var;j++){
        aux[cont] = toTruncate[i];
        cont++;
        i++;
    }
    for(int k=0;k<8;k++) toTruncate[k] = aux[k];
    return cont;
}

int getResister(int rd, char nickName[4]){
    char nickNames[33][4] = {{'z','e','r','o'},{'r','a'},{'s','p'},{'g','p'},{'t','p'},{'t','0'},{'t','1'},{'t','2'},{'s','0'},{'s','1'},{'a','0'},{'a','1'},{'a','2'},
    {'a','3'},{'a','4'},{'a','5'},{'a','6'},{'a','7'},{'s','2'},{'s','3'},{'s','4'},{'s','5'},{'s','6'},{'s','7'},{'s','8'},{'s','9'},{'s','1','0'},{'s','1','1'},{'t','4'},
    {'t','3'},{'t','4'},{'t','5'},{'t','6'}};
    int size = 2;
    if(rd == 0) size = 4; 
    for(int i=0;i<size;i++){
        nickName[i] = nickNames[rd][i];
    }
    return size;
}

int compareName(unsigned char file[100000], int adressToCompare){
    int cont = 0;
    char text[5] = {0x2e, 0x74, 0x65, 0x78, 0x74};

    for(int i = 0;i<5; i++){
        if(file[adressToCompare+i] == text[i]) cont += 1;
    }
    if(cont == 5) return 1;
    else return 0;
}

int getOpcode(int instruc, int mask){  
    int cut = instruc & mask;
    return cut;
}

int isNegative(unsigned int toSee, char immediate[20], int base){
    int verify = toSee >> 31;
    int size;

    if(verify == 1){
        int out = -toSee; 
        getString(out, base, immediate);
        size = cutZeros(immediate) +1;
        addMinus(immediate);
    }
    else {
        getString(toSee, base, immediate);
        size = cutZeros(immediate);
    }
    return size;
}

void getLabel(unsigned char file[100000], inicialInfos (*firstPos), int vma){    
    for(int i=0;i<(*firstPos).sizeSTVec;i++){
        if(vma == (*firstPos).sectionTable[i]){
            write(1, " ",1);
            write(1, "<",1);
            write(1, &file[(*firstPos).sectionTable[i+1]], strLen(file, (*firstPos).sectionTable[i+1])); 
            write(1, ">",1);
            break;
        }
    }
}

int getType(int opcode){
    if(opcode == 0x33) return 1; //R
    if(opcode == 0x67 || opcode == 0x3 || opcode == 0x13 || opcode == 0xf || opcode == 0x73) return 2; //I
    if(opcode == 0x23) return 3; //S
    if(opcode == 0x63) return 4; //B
    if(opcode == 0x37 || opcode == 0x17) return 5; //U
    if(opcode == 0x6f) return 6; //J
    else return 7;
}

void typeR(int fullInstruc){     
    int mid = getOpcode(fullInstruc, 0x7000) >> 12;  
    int top = getOpcode(fullInstruc, 0xfe000000) >> 25;  
    char nickName[4];
    int rd = getOpcode(fullInstruc, 0x780) >> 7;                        
    int r1 = getOpcode(fullInstruc, 0xF8000) >> 15;
    int r2 = getOpcode(fullInstruc, 0x1F00000) >> 20;                        

    if(mid == 0x00 && top == 0x00) write(1, "add", 3);   
    else if(mid == 0x00 && top == 0x20) write(1, "sub", 3);
    else if(mid == 0x01 && top == 0x00) write(1, "sll", 3);
    else if(mid == 0x02 && top == 0x00) write(1, "slt", 3);
    else if(mid == 0x03 && top == 0x00) write(1, "sltu", 4);
    else if(mid == 0x04 && top == 0x00) write(1, "xor", 3);
    else if(mid == 0x05 && top == 0x00) write(1, "slr", 3);
    else if(mid == 0x05 && top == 0x20) write(1, "sra", 3);
    else if(mid == 0x06 && top == 0x00) write(1, "or", 2);
    else if(mid == 0x07 && top == 0x00) write(1, "and", 3);
    else {
        write(1,"<unknown>", 9); 
        write(1, "\n", 1);
        return;
    }
    int size = getResister(rd, nickName);
    write(1, " ", 1);
    write(1, &nickName[0], size);
    write(1, ",", 1);
    
    size = getResister(r1, nickName);
    write(1, " ", 1);
    write(1, &nickName[0], size);
    write(1, ",", 1);

    size = getResister(r2, nickName);
    write(1, " ", 1);
    write(1, &nickName[0], size);
    write(1, "\n", 1); 
}

void typeI(int fullInstruc, int opcode){  
    int mid = getOpcode(fullInstruc, 0x7000) >> 12;  
    int top = getOpcode(fullInstruc, 0xfe000000) >> 25;  
    int topEbreak = getOpcode(fullInstruc, 0x300000) >> 20;  

    char nickName[4];
    char immediate[9];

    if(opcode == 0x67) {
        write(1, "jalr", 4);
        int rd = getOpcode(fullInstruc, 0x780) >> 7;   
        int r1 = getOpcode(fullInstruc, 0xF8000) >> 15;    

        int im1 = getOpcode(fullInstruc, 0xFFF00000) >> 20;
        int imS = im1;                    
        int a = getOpcode(fullInstruc, 80000000) >> 31;                                      
        for(int i=0;i<20;i++){
            imS += a << (12+i);
        }

        int size = getResister(rd, nickName);
        write(1, " ", 1);
        write(1, &nickName[0], size);
        write(1, ",", 1);

        int sizeIm = isNegative(imS,immediate,10);
        write(1, " ", 1);

        if(sizeIm == 0) write(1, "0", 1);
        else write(1, &immediate[0], sizeIm); 

        size = getResister(r1, nickName);
        write(1, "(", 1);
        write(1, &nickName[0], size);
        write(1, ")", 1);
        write(1, "\n", 1);
    }
    else if(opcode == 0x03){
        int rd = getOpcode(fullInstruc, 0x780) >> 7;                       
        int r1 = getOpcode(fullInstruc, 0xF8000) >> 15;
        int im1 = getOpcode(fullInstruc, 0xFFF00000) >> 20;
        int imS = im1;                    

        if(mid == 0x00){
            write(1, "lb", 2);
        }
        else if(mid == 0x01){
            write(1, "lh", 2);
        }
        else if(mid == 0x02){
            write(1, "lw", 2);
        }
        else if(mid == 0x04){
            write(1, "lbu", 3);
        }
        else if(mid == 0x05){
            write(1, "lhu", 3);
        }
        else{
            write(1,"<unknown>", 9);  
            write(1, "\n", 1);
            return;
        }
    
        int size = getResister(rd, nickName);
        write(1, " ", 1);
        write(1, &nickName[0], size);
        write(1, ",", 1);

        int sizeIm = isNegative(imS, immediate, 10);
        write(1, " ", 1);
        if(sizeIm == 0) write(1, "0", 1);
        else write(1, &immediate[0], sizeIm); 

        size = getResister(r1, nickName);
        write(1, "(", 1);
        write(1, &nickName[0], size);
        write(1, ")", 1);
        write(1, "\n", 1);
    }
    else if(opcode == 0x13){
        int im1 = getOpcode(fullInstruc, 0xFFF00000) >> 20;
        int imS = im1;                    
        int a = getOpcode(fullInstruc, 80000000) >> 31;                                      
        for(int i=0;i<20;i++){
            imS += a << (12+i);
        }

        if(mid == 0x00){
            write(1, "addi", 4);
        }
        else if(mid == 0x02){
            write(1, "slti", 4);
        }
        else if(mid == 0x03){
            write(1, "sltiu", 5);
        }
        else if(mid == 0x04){
            write(1, "xori", 4);
        }
        else if(mid == 0x06){
            write(1, "ori", 3);
        }
        else if(mid == 0x07){
            write(1, "andi", 4);
        }
        else{  //plha o top
            if(mid == 0x01 && top == 0x00){
                write(1, "slli", 4);
            }
            else if(mid == 0x05){
                if(top == 0x00){
                    write(1, "srli", 4);
                }
                else if(top == 0x20){
                    write(1, "srai", 4);
                }
                else{
                    write(1,"<unknown>", 9); 
                    write(1, "\n", 1);
                    return;
                }
            }
            else {
                write(1,"<unknown>", 9);  
                write(1, "\n", 1);
                return;
            }
        }
        
        int rd = getOpcode(fullInstruc, 0x780) >> 7;                        
        int r1 = getOpcode(fullInstruc, 0xF8000) >> 15;
        int size = getResister(rd, nickName);
        write(1, " ", 1);
        write(1, &nickName[0], size);
        write(1, ",", 1);

        size = getResister(r1, nickName);
        write(1, " ", 1);
        write(1, &nickName[0], size);
        write(1, ",", 1);

        int sizeIm = isNegative(imS, immediate, 10);
        write(1, " ", 1);
        if(sizeIm == 0) write(1, "0", 1);
        else write(1, &immediate[0], sizeIm); 

        write(1, "\n", 1); 
    }
    else if(opcode == 0xf){  
        int pred[4] = {0x8000000, 0x4000000, 0x2000000, 0x1000000};    
        int succ[4] = {0x800000, 0x400000, 0x200000, 0x100000};
        int letters[4][1] = {{'i'}, {'o'}, {'r'}, {'w'}};
        if(mid == 0x00){
            write(1, "fence", 5);
            write(1, " ", 1);
            for(int i=0;i<4;i++){
                int toCompare = (fullInstruc & pred[i]) >> (27-i);
                if(toCompare == 1) write(1, &letters[i], 1);
            }
            write(1, ", ", 2);
            for(int i=0;i<4;i++){
                int toCompare = (fullInstruc & succ[i]) >> (23-i);
                if(toCompare == 1) write(1, &letters[i], 1);
            }
            write(1, "\n", 1);
        }
        else if(mid == 0x01){
            write(1, "fence.i\n", 8);           
        }
        else{
            write(1,"<unknown>", 9); 
            write(1, "\n", 1);
        }
    }
    else if(opcode == 0x73){
        if(mid == 0x00){            
            if(topEbreak == 0x00){
                write(1, "ecall\n", 6);
            }
            else if(topEbreak == 0x01){
                write(1, "ebreak\n", 7);
            }
            else{
                write(1,"<unknown>", 9); 
                write(1, "\n", 1);
            }
        }
        else{
            int rd = getOpcode(fullInstruc, 0x780) >> 7;                        
            int r1 = getOpcode(fullInstruc, 0xF8000) >> 15; 
            int csr = getOpcode(fullInstruc, 0x3FF80000) >> 20;
            int special = 0;

            if(mid == 0x01){
                write(1, "csrrw", 5);
            }
            else if(mid == 0x02){
                write(1, "csrrs", 5);
            }
            else if(mid == 0x03){
                write(1, "csrrc", 5);
            }
            else if(mid == 0x05){
                write(1, "csrrwi", 6);
                special = 1;
            }
            else if(mid == 0x06){
                write(1, "csrrsi", 6);
                special = 1;
            }
            else if(mid == 0x07){
                write(1, "csrrci", 6);
                special = 1;
            }
            else{
                write(1,"<unknown>", 9); 
                write(1, "\n", 1);
                return;
            }
            
            int size = getResister(rd, nickName);
            write(1, " ", 1);
            write(1, &nickName[0], size);
            write(1, ",", 1);
            write(1, " ", 1);

            int sizeCsr = isNegative(csr, immediate, 10);
            if(sizeCsr == 0) write(1, "0", 1);
            else write(1, &immediate[0], sizeCsr); 
            write(1, ",", 1);

            write(1, " ", 1);
            if(!special){
                size = getResister(r1, nickName);
                write(1, &nickName[0], size);
            }
            else{
                int sizeImm = isNegative(r1, immediate, 10);
                if(sizeImm == 0) write(1, "0", 1);
                else write(1, &immediate[0], sizeImm); 
            }
            write(1, "\n", 1); 
        }
    }
    else{
        write(1,"<unknown>", 9); 
        write(1, "\n", 1);
    }
}

void typeS(int fullInstruc){     
    char nickName[4];
    char immediate[20];
    int mid = getOpcode(fullInstruc, 0x7000) >> 12;

    int r1 = getOpcode(fullInstruc, 0xF8000) >> 15;
    int r2 = getOpcode(fullInstruc, 0x1F00000) >> 20;    

    int im1 = getOpcode(fullInstruc, 0xF80) >> 7;     
    int im2 = getOpcode(fullInstruc, 0xFE000000) >> 20;
    int imS = im1 + im2;                    
   
    if(mid == 0x00) write(1, "sb", 2);
    else if(mid == 0x01) write(1, "sh", 2);
    else if(mid == 0x02) write(1, "sw", 2);
    else{
        write(1,"<unknown>", 9); 
        write(1, "\n", 1);
        return;
    }

    int size = getResister(r2, nickName);
    write(1, " ", 1);
    write(1, &nickName[0], size);
    write(1, ",", 1);

    int sizeIm = isNegative(imS, immediate, 10);           
    write(1, " ", 1);
    if(sizeIm == 0) write(1, "0", 1);
    else write(1, &immediate[0], sizeIm); 

    size = getResister(r1, nickName);
    write(1, "(", 1);
    write(1, &nickName[0], size);
    write(1, ")", 1);
    write(1, "\n", 1);
}

void typeB(int fullInstruc, int vma, inicialInfos (*firstPos), unsigned char file[100000]){
    char nickName[4];
    char immediate[20];
    int mid = getOpcode(fullInstruc, 0x7000) >> 12;

    int r1 = getOpcode(fullInstruc, 0xF8000) >> 15;                        
    int r2 = getOpcode(fullInstruc, 0x1F00000) >> 20; 

    int im1 = getOpcode(fullInstruc, 0xF00) >> 8;                
    int im2 = getOpcode(fullInstruc, 0x7E000000) >> 20;
    int imY = getOpcode(fullInstruc, 0x80) << 4;
    int a = getOpcode(fullInstruc, 0x80000000) >> 19;    
    int imS = (im1 << 1) + im2 + imY + a;                    
                 
    if(mid == 0x00) write(1, "beq", 3);
    else if(mid == 0x01) write(1, "bne", 3);
    else if(mid == 0x04) write(1, "blt", 3);
    else if(mid == 0x05) write(1, "bge", 3);
    else if(mid == 0x06) write(1, "bltu", 4);
    else if(mid == 0x07) write(1, "bgeu", 4);
    else{
        write(1,"<unknown>", 9); 
        write(1, "\n", 1);
        return;
    }

    int size = getResister(r1, nickName);
    write(1, " ", 1);
    write(1, &nickName[0], size);
    write(1, ",", 1);

    size = getResister(r2, nickName);
    write(1, " ", 1);
    write(1, &nickName[0], size);
    write(1, ",", 1);

    imS += vma;
    immediate[0] = '0';
    immediate[1] = 'x';
    getString(imS, 16,immediate+2);  
    int sizeIm = cutZeros(immediate+2);
    write(1, " ", 1);
    write(1, &immediate[0], sizeIm+2);  
    getLabel(file,firstPos, imS);
    write(1, "\n", 1);
}

void typeU(int fullInstruc){  
    char nickName[4];
    char immediate[9];

    if(getOpcode(fullInstruc, 0x3f) == 0x37) write(1, "lui",3);
    else if(getOpcode(fullInstruc, 0x3f) == 0x17) write(1, "auipc",5);
    else{
        write(1,"<unknown>", 9); 
        write(1, "\n", 1);
        return;
    }

    int imS = getOpcode(fullInstruc, 0xFFFFF000) >> 12;    
    int rd = getOpcode(fullInstruc, 0x780) >> 7;      

    int size = getResister(rd, nickName);
    write(1, " ", 1);
    write(1, &nickName[0], size);
    write(1, ",", 1);

    int sizeIm = isNegative(imS, immediate, 10);         
    write(1, " ", 1);
    if(sizeIm == 0) write(1, "0", 1);
    else write(1, &immediate[0], sizeIm);   
    write(1, "\n", 1);
}

void typeJ(int fullInstruc, int vma, inicialInfos (*firstPos), unsigned char file[100000]){  
    char nickName[4];
    char immediate[20];
    int rd = getOpcode(fullInstruc, 0x780) >> 7; 

    int im1 = getOpcode(fullInstruc, 0xFF000);     
    int im2 = getOpcode(fullInstruc, 0x7FE00000) >> 20;
    int imS = im1 + im2 + (getOpcode(fullInstruc, 0x100000) >> 9);                    
    int a = getOpcode(fullInstruc, 0x80000000) >> 11;
    imS += a;

    int size = getResister(rd, nickName);
    write(1, "jal", 3);
    write(1, " ", 1);
    write(1, &nickName[0], size);
    write(1, ",", 1);

    imS += vma;
    immediate[0] = '0';
    immediate[1] = 'x';
    getString(imS, 16,immediate+2);                  
    int sizeIm = cutZeros(immediate+2);
    write(1, " ", 1);
    write(1, &immediate[0], sizeIm+2);
    getLabel(file,firstPos, imS);
    write(1, "\n", 1);
}

void getInstrucName(int type, int fullInstruc, int opcode, int vma, inicialInfos (*firstPos), unsigned char file[100000]){  
    if(type == 1) typeR(fullInstruc);   
    else if(type == 2) typeI(fullInstruc, opcode);   
    else if(type == 3) typeS(fullInstruc);  
    else if(type == 4) typeB(fullInstruc, vma, firstPos, file);   
    else if(type == 5) typeU(fullInstruc);   
    else if(type == 6) typeJ(fullInstruc, vma, firstPos, file);  
    else{
        write(1, "<unknown>", 9);
        write(1, "\n", 1);
    }
}

void getInitials(inicialInfos *firstPos, unsigned char file[100000]){
    int aux = 0;
    for(int i=0;i<4;i++){
        aux += elevated(file[0x20+i], i, 1<<8); 
    }
    (*firstPos).e_shoff = aux;

    aux = 0;
    for(int i=0;i<2;i++){
        aux += elevated(file[0x30+i], i, 1<<8); 
    }
    (*firstPos).e_shnum = aux;

    aux = 0;
    for(int i=0;i<2;i++){
        aux += elevated(file[0x32+i], i, 1<<8); 
    }
    (*firstPos).e_shstrndx = aux;
}

void sectionTable(inicialInfos *firstPos, unsigned char file[100000], int show){   
    int startStrTab = (0x28*(*firstPos).e_shstrndx)+(*firstPos).e_shoff;   
    int sh_offset = getAdress(file, startStrTab + 0x10);  //onde começa os nomes   
    (*firstPos).sh_offset = sh_offset;
    char converted[9];

    if(show){
        write(1, "\n", 1);
        write(1, "Sections:", 9);
        write(1, "\n", 1);
        write(1, "Idx Name\tSize\t\tVMA", 18);
        write(1, "\n", 1);
    }

    for(int j=0;j<(*firstPos).e_shnum;j++){
        int aux = getAdress(file, (*firstPos).e_shoff+(0x28*j));
        aux = aux+sh_offset;

        if(show){                         
            getString(j, 10, converted);
            write(1, " ", 1);
            if(j==0) write(1, &converted[7], 1);
            else{
                int sizeTruncate = cutZeros(converted);
                write(1, &converted[0], sizeTruncate);
                write(1, " ", 1);
            }
        }
        
        int sizeSH = getAdress(file, (*firstPos).e_shoff+(0x28*j)+0x14);
        getString(sizeSH, 16, converted);

        if(show){
            write(1, &file[aux], strLen(file, aux));
            write(1, "\t", 1);
            write(1,converted,8);
            write(1, "\t", 1);
        }
        int vma = getAdress(file, (*firstPos).e_shoff+(0x28*j)+0x0C);
        getString(vma, 16, converted);
        
        if(compareName(file, aux)) (*firstPos).vmaText = vma;

        if(show){
            write(1, converted, 8);
            write(1, "\n", 1);
        }
        
        //pegar o offset da symtab
        int symtabPos = getAdress(file, (*firstPos).e_shoff+(0x28*j)+0x04);  
        if(symtabPos == 0x02) {     //Symtab
            (*firstPos).sh_offsetSymtab = getAdress(file, (*firstPos).e_shoff+(0x28*j)+0x10);  
            (*firstPos).sizeSymtab = getAdress(file, (*firstPos).e_shoff+(0x28*j)+0x14);  
        }
        if(symtabPos == 0x03){      //Strtab
            (*firstPos).sh_offsetStrtab = getAdress(file, (*firstPos).e_shoff+(0x28*j)+0x10);
        }
        if(symtabPos == 0x01 && compareName(file, aux)){      //.text
            (*firstPos).sh_offsetText = getAdress(file, (*firstPos).e_shoff+(0x28*j)+0x10);
            (*firstPos).sizeText = getAdress(file, (*firstPos).e_shoff+(0x28*j)+0x14);
        }
    } 
    write(1, "\n", 1);
}

void symTab(inicialInfos *firstpos, unsigned char file[100000], int show){ 
    char converted[9];
    sectionTable(firstpos, file, 0);

    if(show){
        write(1, "SYMBOL TABLE:", 13);
        write(1,"\n",1);
    }
    
    for(int i=0;i<(*firstpos).sizeSymtab/16 - 1;i++){             
        int nameOffset = getAdress(file, (0x10*i)+(*firstpos).sh_offsetSymtab+0x10);
        int index = (*firstpos).sh_offsetStrtab+nameOffset;
        int sizeStr = strLen(file,index);

        int adress = getAdress(file, (0x10*i)+(*firstpos).sh_offsetSymtab+0x14);
        getString(adress, 16, converted);

        if(show){
            write(1, converted, 8);
            write(1,"\t",1);
        }
        
        int info = file[(0x10*i)+(*firstpos).sh_offsetSymtab+0x1c];
        info = info>>4;

        int shndx = file[(0x10*i)+(*firstpos).sh_offsetSymtab+0x1e];  
        int locSection = getAdress(file, (*firstpos).e_shoff + (shndx*0x28));
        int locName = (*firstpos).sh_offset + locSection;

        if(show){
            if(info == 0) write(1, "l",1);
            if(info == 1) write(1, "g",1);
            write(1, "\t",1);
        
            if(shndx >= (*firstpos).e_shnum) write(1, "*ABS*", 5);
            else write(1, &file[locName], strLen(file, locName));
            write(1,"\t",1);

            int sizeSymbol = getAdress(file, (0x10*i)+(*firstpos).sh_offsetSymtab+0x18); 
            getString(sizeSymbol, 16, converted);

            write(1, converted, 8);
            write(1,"\t",1);

            write(1, &file[index],sizeStr);
            write(1,"\n",1);
        }
        (*firstpos).sectionTable[(*firstpos).sizeSTVec] = adress;
        (*firstpos).sectionTable[(*firstpos).sizeSTVec+1] = index;
        (*firstpos).sizeSTVec += 2;
    }
}

void assemblyCode(inicialInfos *firstPos, unsigned char file [100000]){
    sectionTable(firstPos, file, 0);
    symTab(firstPos, file, 0);
    char converted[9];
    char convertedFull[9];
    char convertedVMA[8];

    write(1, "Disassembly of section .text:\n", 30);

    for(int i=0;i<(*firstPos).sizeText/4;i++){

        int fullInstruc = getAdress(file, (*firstPos).sh_offsetText+(i*4));
        int opcode = getOpcode(fullInstruc, 0x7f);
        int type = getType(opcode);
        int vma = (*firstPos).vmaText + 4*i;
        int sizeSTVec = (*firstPos).sizeSTVec;

        for(int j=0;j<sizeSTVec;j++){
            if(vma == (*firstPos).sectionTable[j]){
                int adressName = (*firstPos).sectionTable[j+1];
                int sizeSymbol = strLen(file, adressName);
                getString((*firstPos).sectionTable[j], 16, converted);
                write(1, "\n", 1);
                write(1, &converted[0], 8);
                write(1, " <", 2);
                write(1, &file[adressName], sizeSymbol);
                write(1, ">:\n", 3);
            }
        }
        
        getString(vma, 16, convertedVMA); 
        int sizeTruncate = cutZeros(convertedVMA);
        write(1, &convertedVMA[0], sizeTruncate);
        write(1, ": ", 2);
        getStringInst(fullInstruc, convertedFull);
        getInstrucName(type, fullInstruc, opcode, vma, firstPos, file);
    }
}

int main(int argc, char *argv[]){
    unsigned char file[100000];
    inicialInfos firstPos;
    firstPos.e_shnum = 0;
    firstPos.e_shoff = 0;
    firstPos.e_shstrndx = 0;
    firstPos.sh_offset = 0;
    firstPos.sh_offsetSymtab = 0;
    firstPos.sizeSymtab = 0;
    firstPos.sh_offsetStrtab = 0;
    firstPos.sh_offsetText = 0;
    firstPos.sizeText = 0;
    firstPos.vmaText = 0;
    firstPos.sizeSTVec = 0;

    readFile(argv, file);
    getInitials(&firstPos, file);

    write(1, "\n", 1);
    write(1, &argv[2][0], strLenSigned(argv[2], 0));
    write(1, ":", 1);
    write(1, "\tfile format elf32-littleriscv", 30);
    write(1, "\n", 1);

    if(argv[1][1] == 'h') sectionTable(&firstPos, file, 1);  
    if(argv[1][1] == 't') symTab(&firstPos, file, 1);
    if(argv[1][1] == 'd') assemblyCode(&firstPos, file);
    
    return 0;
}