#include <stdio.h>
#include <stdlib.h>
int max(int a, int b) {
    return (a > b) ? a : b;
}
void optimizeStudyTime(int n, int total_hours, int time_req[], int marks[], char subjects[][50]) {
    int i, w;
    int dp[n + 1][total_hours + 1];

    for (i = 0; i <= n; i++) {
        for (w = 0; w <= total_hours; w++) {
            if (i == 0 || w == 0)
                dp[i][w] = 0;
            else if (time_req[i - 1] <= w)
                dp[i][w] = max(marks[i - 1] + dp[i - 1][w - time_req[i - 1]], dp[i - 1][w]);
            else
                dp[i][w] = dp[i - 1][w];
        }
    }
    printf("\nTotal Marks: %d\n", dp[n][total_hours]);
    printf("Selected Subjects:\n");
    int res = dp[n][total_hours];
    w = total_hours;
    for (i = n; i > 0 && res > 0; i--) {
        if (res == dp[i - 1][w])
            continue;
        else {
            printf("- %s (%d hours, %d marks)\n", subjects[i - 1], time_req[i - 1], marks[i - 1]);
            res = res - marks[i - 1];
            w = w - time_req[i - 1];
        }
    }
}
int main() {
    int n, total_hours;
    if (scanf("%d", &n) != 1) return 1;
    if (scanf("%d", &total_hours) != 1) return 1;
    char subjects[n][50];
    int time_req[n];
    int marks[n];
    for (int i = 0; i < n; i++) {
        if (scanf("%s %d %d", subjects[i], &time_req[i], &marks[i]) != 3) return 1;
    }
    optimizeStudyTime(n, total_hours, time_req, marks, subjects);

    return 0;
}

