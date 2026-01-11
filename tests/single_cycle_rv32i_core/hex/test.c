int g1 = 123;
int g2 = -456;
int g3;

int add_many(int a, int b, int c) {
    int x = a + b;
    int y = x + c;
    return y;
}

int mul_pseudo(int a, int b) {
    return a * b;  
}

int sum_array(int *p, int n) {
    int s = 0;
    for (int i = 0; i < n; i++) {
        s += p[i];
    }
    return s;
}

int recurse(int x) {
    if (x <= 1) return 1;
    return x + recurse(x - 1);
}

int main() {
    int local1 = 50;
    int local2 = -20;
    int arr[5] = {1, 2, 3, 4, 5};

    int v1 = add_many(local1, g1, g2);     
    int v2 = mul_pseudo(7, -3);          
    int v3 = sum_array(arr, 5);            
    int v4 = recurse(5);              

    g3 = v1 + v2 + v3 + v4;               

    return g3;                            
}

