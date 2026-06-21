/*
ram[0x0] == 0xAAAAAAAA PASS
ram[0x0] == 0xBBBBBBBB FAIL
*/

#define G3_ADDR 0x2000
volatile int * const g3_addr = (int *)G3_ADDR;

void int_to_string_simple(int num, char *str) {
    int i = 0, temp = num;

    if (temp == 0) {
        str[i++] = '0';
        str[i] = '\0';
        return;
    }

    while (temp > 0) {
        int q = 0;
        int rem = temp;
        
        // Manual division and modulo using only basic subtraction
        while (rem >= 10) {
            rem -= 10;
            q++;
        }
        
        str[i++] = rem + '0';
        temp = q;
    }
    
    str[i] = '\0';

    // Reverse string
    for (int j = 0; j < i/2; j++) {
        char t = str[j];
        str[j] = str[i-j-1];
        str[i-j-1] = t;
    }
}

void int_to_string_complex(int num, char *str) {
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
    char s[4];
    char c[4];
    int_to_string_simple(129, s);
    int_to_string_complex(129, s);

    if (s[0] == '1' && s[1] == '2' && s[2] == '9' && s[3] == '\0' 
        && s[0] == c[0], s[1] == c[1], s[2] == c[2]) {
        *g3_addr = 0xAAAAAAAA;
    } else {
        *g3_addr = 0xBBBBBBBB;
        *(g3_addr + 1) = s[0];
        *(g3_addr + 2) = s[1];
        *(g3_addr + 3) = s[2];
    }
    
    return 0;
}



