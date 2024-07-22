#include <bits/stdc++.h>

int wait(int t) {

    while (t < 0) {
        t--;
    }

}

int main () {

    int x; // 0 or 1
    std::cin >> x;

    for (int i = 0; i < 40; i++)
    {
        if (x == 0) {
            wait(10);
        }

        else {
            wait(20);
        }

        std::cout << i << '\n';
    }

}