#include <bits/stdc++.h>

int wait(int t) {

    int i = 0;
    while (i != t) {
        i++;
    }

}

int main () {

    int x; // 0 or 1
    int k;
    std::cin >> x;
    std::cin >> k;

    int i = 0;
    while(i != k);
    {
        if (x == 0) {
            wait(10);
        }

        else {
            wait(20);
        }

        i++;
        std::cout << i << '\n';
    }   

}