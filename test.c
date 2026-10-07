#include<stdio.h>
int main()
{
char f[50],l[50],full[100];
int i=0,j=0,length=0;
printf("Enter the first name:");
scanf("%49s",f);
printf("Enter the last name:");
scanf("%49s",l);
while(f[i]!='\0'){
full[length++]=f[i++];
}
full[length++]=' ';
while(l[j]!='\0'){
full[length++]=l[j++];
}
full[length++]='\0';
printf("The full name is %s\n",full);
if(length>20){
printf("The name wont fit in the screen\n");
}
else
{
printf("The name will fit in the screen\n");
}
return 0;
}
