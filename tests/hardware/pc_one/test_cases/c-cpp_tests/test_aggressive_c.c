/*
ram[0x0] == 99 TEST PASSES
*/

#define G3_ADDR 0x2000
volatile int * const g3_addr = (int *)G3_ADDR;

void int_to_string(int num, char *str) {
    int i = 0, temp = num;

    if (num == 0) {
        str[i] = '0';
        i++;
        str[i] = '\0';
        return;
    }

    while (temp > 0) {
        str[i++] = (temp % 10) + '0';
        temp /= 10;
    }

    str[i] = '\0';

    // reverse string
    for (int j = 0; j < i/2; j++) {
        char t = str[j];
        str[j] = str[i-j-1];
        str[i-j-1] = t;
    }
}

int bios(){
    char s[10];
    int_to_string(64, s);

    int result;
    if(s[0] == '6' && s[1] == '4' && s[2] == '\0'){
        result = 0xAAAAAAAA;
    } else {
        result = 0xBBBBBBBB;
    }

    return 0;
}



