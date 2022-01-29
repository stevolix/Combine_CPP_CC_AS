#include <iostream>

// Forward declaration for subfunc1
int subfunc1();

// Forward declaration external C and AS
extern "C" {
    int subfunc2(); // C
    int subfunc3(); // AS
}

int main() {
    using namespace std;
    cout << subfunc1() << " " << subfunc2() << " " << subfunc3() << endl;
    return 0;
}

