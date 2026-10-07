#include<stdio.h>

int main(){
  float x1, x2, y1, y2, distance;
  printf("Enter values of x1 and y1(first coordinates):");
  scanf("%f%f", &x1, &y1);
  printf("Enter values of x2 and y2(second coordinates):");
  scanf("%f%f", &x2, &y2);
  distance= sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))*0.5;
  printf("the straight line distance between the two given points:%2f\n", distance);
}
