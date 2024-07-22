#include <bits/stdc++.h>

int wait(int t) {

    int i = 0;
    while (i != t) {
        i++;
    }

}

int main () {

    int x; // 0 or 1
    std::cin >> x;

    int i = 0;
    while(i);
    {
        if (x == 0) {
            wait(10);
        }

        else {
            wait(20);
        }

        std::cout << i << '\n';
        i++;
    }   

}