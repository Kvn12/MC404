// #include <stdio.h>
int read(int __fd, const void *__buf, int __n){
  int bytes;
  __asm__ __volatile__(
    "mv a0, %1           # file descriptor\n"
    "mv a1, %2           # buffer \n"
    "mv a2, %3           # size \n"
    "li a7, 63           # syscall read (63) \n"
    "ecall \n"
    "mv %0, a0"
    : "=r"(bytes)  // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
  return bytes;
}
 
void write(int __fd, const void *__buf, int __n){
  __asm__ __volatile__(
    "mv a0, %0           # file descriptor\n"
    "mv a1, %1           # buffer \n"
    "mv a2, %2           # size \n"
    "li a7, 64           # syscall write (64) \n"
    "ecall"
    :   // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
}

int strlength(char *str) {                                                                    // APAGAR
    int i;
    for(i = 0; str[i] != '\0' && str[i] != '\n'; i++);
    return i+1;
}

int charToInt(char toConvert){
  int converted;
  if(toConvert == 'a')
    converted = 10;
  else if(toConvert == 'b')
    converted = 11;
  else if(toConvert == 'c')
    converted = 12;
  else if(toConvert == 'd')
    converted = 13;
  else if(toConvert == 'e')
    converted = 14;
  else if(toConvert == 'f')
    converted = 15;
  else if(toConvert == '\0')
    write(1,"oi\n",3);
  else
    converted = toConvert - '0';
  return converted;
}

int position(char digit, int index, int base){
  int aux = charToInt(digit);
  for(int i=0;i < index;i++){
    aux = aux*base;
  }
  return aux;
}

void changeToLet(char strHex[35], int n){  
  // for(int i=2;i<n+2;i++){
  //   int aux = strHex[i];
  //   if(aux == 10) strHex[i] = 'A';
  //   if(aux == 11) strHex[i] = 'B';
  //   if(aux == 12) strHex[i] = 'C';
  //   if(aux == 13) strHex[i] = 'D';
  //   if(aux == 14) strHex[i] = 'E';
  //   if(aux == 15) strHex[i] = 'F';
  // }
  for(int i=2;i<n+2;i++){
    int aux = strHex[i];
    if(aux == 58) strHex[i] = 'a';
    if(aux == 59) strHex[i] = 'b';
    if(aux == 60) strHex[i] = 'c';
    if(aux == 61) strHex[i] = 'd';
    if(aux == 62) strHex[i] = 'e';
    if(aux == 63) strHex[i] = 'f';
  }
}

void toNegative(char strBin[35]){
  char auxStr[35];
  int gotIt = 0;
  for(int i=2;i < 35;i++){      
    if(strBin[i] == '0') auxStr[i] = '1';
    if(strBin[i] == '1') auxStr[i] = '0';
  } 
  for(int j=0;j < 35;j++){  
    if(auxStr[34-j] == 'b') break;
    if(auxStr[34-j] == '1') auxStr[34-j] = '0';
    else if(auxStr[34-j] == '0') {
      auxStr[34-j] = '1';
      gotIt = 1;
      break;
    }
  }
  if(gotIt){
    for(int k=2;k<34;k++){
      strBin[k] = auxStr[k];
    }
  }
  else{
    strBin[2] = '1';
  }
}

void decToBin(char str[35], char strBin[35], int n){  
  int sum = 0;
  int interactions = 0;
  int neg = 0;
  int size = 0;
  char aux[35];
  char auxStr[35];
  char auxChar;

  auxStr[0] = '0';
  auxStr[1] = 'b';
  
  if(str[0] == '-') neg = 1;
  for(int i = 0;i< n-1; i++){  
    if(neg && n-2-i > 0) sum += position(str[n-2-i], i, 10);
    if(!neg) sum += position(str[n-2-i], i, 10);
  }
  // write(1,"tchau\n",6);
  while(sum > 0){
    auxChar = sum%2 + '0';
    aux[interactions] = auxChar;
    sum = sum/2;
    interactions += 1;
  }
  for(int j=0;j < interactions;j++){
    strBin[2+j] = aux[interactions-1-j];
  }
  strBin[interactions+2] = '\0';
  //size = strlength(strBin);
  size = interactions +3;

  //completar com zeros
  if(size-1<=32){  //completar as posicoes
    for(int i=0;i<size-1;i++){
      auxStr[33-i] = strBin[size-2-i];
    }
    for(int j=0;j<34-(size-1);j++){ 
      auxStr[j+2] = '0';
    }
    for(int k=0;k<34;k++){
      strBin[k] = auxStr[k];
    }
    strBin[34] = '\0';
  }
  //chamar pra complemento de 2
  if(neg) toNegative(strBin);
}

void hexToBin(char str[35], char strBin[35], int n){  
  int cont = 2;
  int size;
  char bins[4];
  char auxChar;
  char auxStr[35];

  strBin[0] = '0'; 
  strBin[1] = 'b';
  auxStr[0] = '0'; 
  auxStr[1] = 'b';

  for(int i=2; i < n-1; i++){
    int result = charToInt(str[i]);
    int interactions = 0;
    while(result > 0){    
      auxChar = result%2 + '0';
      bins[interactions] = auxChar;
      result = result/2;
      interactions += 1;
    }
    for(int j=0; j < 4-interactions; j++){  
      bins[interactions+j] = '0'; 
    }
    for(int a=0; a < 4;a++){ 
      strBin[cont] = bins[3-a]; 
      cont += 1;   
    }
    for(int b=0;b<4;b++){
      bins[b] = 0;
    }
  }
  //completar os 32 bits
  size = cont + 1;
  if(size-1<32){  
    for(int i=0;i<size-2;i++){ 
      auxStr[33-i] = strBin[size-2-i]; 
    }
    for(int j=0;j<35-size;j++){ 
      auxStr[j+2] = '0';
    }
    for(int k=0;k<34;k++){
      strBin[k] = auxStr[k];
    }
  }
  strBin[34] = '\0';
}  

void decToHex(char str[35], char strHex[35], int n){ //se for negativo
  char aux[35];
  int sum = 0;
  int interactions = 0; 
  char auxChar;

  strHex[0] = '0';
  strHex[1] = 'x';
  //se n negativo
  for(int i =0;i< n-1; i++){  
    sum += position(str[n-2-i], i, 10);
  }

  while(sum > 0){
    auxChar = sum%16 + '0';
    aux[interactions] = auxChar;
    sum = sum/16;
    interactions += 1;
  }
  for(int j=0;j < interactions;j++){
    strHex[2+j] = aux[interactions-1-j];
  }
  changeToLet(strHex, interactions);

  strHex[interactions+2] = '\0';

  

  //se for neghativo q eh o foda
  //jogando pra 
}

void hexToDec(char str[35], char strDec[35], char strBin[35], int n, int endianess){ 
  int cont = 0;
  int aux[35];
  int neg = 0;
  char auxChar;
  unsigned int sum = 0;

  if(strBin[2]== '1' && !endianess) {
    strDec[0] = '-';
    neg = 1;
  }
  for(int i=0;i<n-3;i++){ 
    sum += position(str[n-2-i], i, 16);
  }
  if(sum < 0) sum = -1*sum;
  while(sum > 0){
    aux[cont] = sum%10;
    sum = sum/10;
    cont += 1;   
  }
  for(int j=0;j<cont;j++){
    if(neg){
      auxChar = aux[cont-1-j] + '0';
      strDec[j+1] = auxChar;
    }
    else{
      auxChar = aux[cont-1-j] + '0';
      strDec[j] = auxChar;
    }
  }
  if(neg) strDec[cont+1] = '\0';
  else strDec[cont] = '\0';
}

void binToHex(char strBin[35], char strHex[34]){
  int cont = 0;
  int index = 1;
  int sum = 0;
  char auxChar;
  char auxStr[20];
  char auxStrFour[4];

  for(int i=0;i<35;i++){
    auxStrFour[4-index] = strBin[33-i];
    index += 1;
    if(index-1 == 4){  //completou 4
      int sum = 0;
      for(int j=0;j<4;j++){
        sum += position(auxStrFour[3-j], j, 2);
      }
      auxChar = sum + '0'; 
      auxStr[cont] = auxChar;  
      index = 1;
      cont += 1;
    }
  }
  strHex[0] = '0';
  strHex[1] = 'x';
  for(int k=0;k<cont;k++){
    strHex[k+2] = auxStr[cont-1-k];
  }
  strHex[cont+2] = '\0';
  changeToLet(strHex, cont);
}

void endianessInverter(char strHex[35], char strHexEnd[35]){
  char auxStr[32];
  int n = strlength(strHex);
  strHexEnd[0] = '0';
  strHexEnd[1] = 'x';
  
  // printf("%d\n", n);
  if(n-1<10){  //completar as posicoes
    for(int i=0;i<n-3;i++){ 
      auxStr[9-i] = strHex[n-2-i];
    }
    for(int j=0;j<11-n;j++){
      auxStr[j+2] = '0';
    }
    strHexEnd[2] = auxStr[8]; 
    strHexEnd[3] = auxStr[9]; 
    strHexEnd[4] = auxStr[6]; 
    strHexEnd[5] = auxStr[7]; 
    strHexEnd[6] = auxStr[4]; 
    strHexEnd[7] = auxStr[5]; 
    strHexEnd[8] = auxStr[2]; 
    strHexEnd[9] = auxStr[3];   
    strHexEnd[10] = '\0';
  }
  else{
    strHexEnd[2] = strHex[8]; 
    strHexEnd[3] = strHex[9]; 
    strHexEnd[4] = strHex[6]; 
    strHexEnd[5] = strHex[7]; 
    strHexEnd[6] = strHex[4]; 
    strHexEnd[7] = strHex[5]; 
    strHexEnd[8] = strHex[2]; 
    strHexEnd[9] = strHex[3];  
    strHexEnd[10] = '\0';
  } 
}

void truncate(char strBin[35]){
  char auxStr[35];
  int validPos;
  int i;

  auxStr[0] = '0';
  auxStr[1] = 'b';

  for(i=2;strBin[i] != '1' && i < 35;i++);
  validPos = i; 
  for(int j=validPos;j<35;j++){
    auxStr[2+(j-validPos)] = strBin[j];
  }
  for(int k=0;k<36-validPos;k++){
    strBin[k] = auxStr[k];
  }
  strBin[1+(35-validPos)] = '\0';
}

void handler(char str[35], char strBin[35], char strDec[35], char strHex[35], char strHexEnd[35], char strDecEnd[35], char strBinEnd[35], int n){ 
  if(str[1] == 'x'){      //hexadecimal
    for(int a=0;a<n;a++){
      strHex[a] = str[a];
    }
    hexToBin(str, strBin, n);
    hexToDec(str, strDec, strBin, n, 0);
    endianessInverter(strHex, strHexEnd);
    //truncate(strBin);
    int k = strlength(strHexEnd);
    hexToBin(strHexEnd, strBinEnd, k);
    hexToDec(strHexEnd, strDecEnd, strBin, k, 1);
  }
  else{                   //decimal
    for(int b=0;b<n;b++){
      strDec[b] = str[b];
    }
    decToBin(str, strBin, n);  
    //truncate(strBin);
    binToHex(strBin, strHex);
    endianessInverter(strHex, strHexEnd);
    int k = strlength(strHexEnd);
    hexToBin(strHexEnd, strBinEnd, k);
    hexToDec(strHexEnd, strDecEnd, strBin, k, 1);
  }
}

int main()
{
  char str[35];
  char strBin[35];
  char strBinEnd[35];  //n to usando pra nda
  char strHex[35];
  char strHexEnd[35];
  char strDec[35];  
  char strDecEnd[35];

  int n = read(0, str, 20);


  // scanf("%s" ,str);
  // int n = strlength(str);

  handler(str, strBin, strDec, strHex, strHexEnd, strDecEnd, strBinEnd, n);

  //chamar o truncate
  //truncate(strBin);
  //truncate(strHex);  //n funfa

  int o = strlength(strBin);
  strBin[o-1] = '\n';
  strBin[o] = '\0';
  write(1, strBin, o);

  int p = strlength(strDec);
  strDec[p-1] = '\n';
  strDec[p] = '\0';
  write(1, strDec, p);

  int q = strlength(strHex);
  strHex[q-1] = '\n';
  strHex[q] = '\0';
  write(1, strHex, q);

  int r = strlength(strDecEnd);
  strDecEnd[r-1] = '\n';
  strDecEnd[r] = '\0';
  write(1, strDecEnd, r);

  // printf("%s\n", strBin);
  // printf("%s\n", strDec);
  // printf("%s\n", strHex);
  // printf("%s\n", strDecEnd);

  return 0;
}
 
void _start(){
  main();
}
