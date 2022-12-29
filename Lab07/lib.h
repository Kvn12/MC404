void puts ( const char * str );

char * gets ( char * str );

int atoi (const char * str);

char *  itoa ( int value, char * str, int base );

int time();

void sleep(int ms);

int approx_sqrt(int x, int iterations);                              

void getPosition(int * x, int * y, int y_b, int x_c, int t_a, int t_b, int t_c, int t_r);

void imageFilter(char * img, int width, int height, char filter[3][3]);

void exit(int code);