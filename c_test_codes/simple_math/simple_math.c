int main() {
    int a = 10;
    int b = 20;
    int c = 0;

    for (int i = 0; i < 5; i++) {
        c = c + (a * i) - b;
    }

    return c;
}