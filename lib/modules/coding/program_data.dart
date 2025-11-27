class ProgramData {
  final String name;
  final String description;
  final String code;
  final String output;

  ProgramData({
    required this.name,
    required this.description,
    required this.code,
    required this.output,
  });
}

class ProgramRepository {
  static final List<ProgramData> allPrograms = [
    ProgramData(
      name: 'Hello World',
      description: 'Basic C program to print Hello World',
      code: '''#include <stdio.h>

int main() {
    printf("Hello, World!\\n");
    return 0;
}''',
      output: 'Hello, World!',
    ),
    
    ProgramData(
      name: 'Prime Number Check',
      description: 'Check if a number is prime',
      code: '''#include <stdio.h>

int main() {
    int n = 29, i, flag = 0;
    
    for(i = 2; i <= n/2; ++i) {
        if(n % i == 0) {
            flag = 1;
            break;
        }
    }
    
    if (flag == 0)
        printf("%d is a prime number.", n);
    else
        printf("%d is not a prime number.", n);
    
    return 0;
}''',
      output: '29 is a prime number.',
    ),
    
    ProgramData(
      name: 'Fibonacci Series',
      description: 'Generate Fibonacci sequence',
      code: '''#include <stdio.h>

int main() {
    int n = 10, t1 = 0, t2 = 1, nextTerm;
    
    printf("Fibonacci Series: ");
    
    for (int i = 1; i <= n; ++i) {
        printf("%d, ", t1);
        nextTerm = t1 + t2;
        t1 = t2;
        t2 = nextTerm;
    }
    
    return 0;
}''',
      output: 'Fibonacci Series: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34,',
    ),
    
    ProgramData(
      name: 'Armstrong Number',
      description: 'Check if number is Armstrong',
      code: '''#include <stdio.h>
#include <math.h>

int main() {
    int num = 153, originalNum, remainder, result = 0, n = 0;
    
    originalNum = num;
    
    // Count digits
    while (originalNum != 0) {
        originalNum /= 10;
        ++n;
    }
    
    originalNum = num;
    
    // Calculate sum
    while (originalNum != 0) {
        remainder = originalNum % 10;
        result += pow(remainder, n);
        originalNum /= 10;
    }
    
    if (result == num)
        printf("%d is an Armstrong number.", num);
    else
        printf("%d is not an Armstrong number.", num);
    
    return 0;
}''',
      output: '153 is an Armstrong number.',
    ),
    
    ProgramData(
      name: 'Factorial',
      description: 'Calculate factorial of a number',
      code: '''#include <stdio.h>

int main() {
    int n = 5, factorial = 1;
    
    for(int i = 1; i <= n; ++i) {
        factorial *= i;
    }
    
    printf("Factorial of %d = %d", n, factorial);
    
    return 0;
}''',
      output: 'Factorial of 5 = 120',
    ),
    
    ProgramData(
      name: 'Palindrome Check',
      description: 'Check if number is palindrome',
      code: '''#include <stdio.h>

int main() {
    int n = 121, reversed = 0, remainder, original;
    
    original = n;
    
    while (n != 0) {
        remainder = n % 10;
        reversed = reversed * 10 + remainder;
        n /= 10;
    }
    
    if (original == reversed)
        printf("%d is a palindrome.", original);
    else
        printf("%d is not a palindrome.", original);
    
    return 0;
}''',
      output: '121 is a palindrome.',
    ),
    
    ProgramData(
      name: 'Bubble Sort',
      description: 'Sort array using bubble sort',
      code: '''#include <stdio.h>

int main() {
    int arr[] = {64, 34, 25, 12, 22, 11, 90};
    int n = 7;
    
    printf("Original array: ");
    for (int i = 0; i < n; i++)
        printf("%d ", arr[i]);
    
    // Bubble sort
    for (int i = 0; i < n-1; i++) {
        for (int j = 0; j < n-i-1; j++) {
            if (arr[j] > arr[j+1]) {
                int temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        }
    }
    
    printf("\\nSorted array: ");
    for (int i = 0; i < n; i++)
        printf("%d ", arr[i]);
    
    return 0;
}''',
      output: '''Original array: 64 34 25 12 22 11 90
Sorted array: 11 12 22 25 34 64 90''',
    ),
    
    ProgramData(
      name: 'Matrix Multiplication',
      description: 'Multiply two matrices',
      code: '''#include <stdio.h>

int main() {
    int a[2][2] = {{1, 2}, {3, 4}};
    int b[2][2] = {{5, 6}, {7, 8}};
    int result[2][2] = {0};
    
    // Multiply matrices
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            for (int k = 0; k < 2; k++) {
                result[i][j] += a[i][k] * b[k][j];
            }
        }
    }
    
    printf("Result:\\n");
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            printf("%d ", result[i][j]);
        }
        printf("\\n");
    }
    
    return 0;
}''',
      output: '''Result:
19 22
43 50''',
    ),
    
    ProgramData(
      name: 'Swap Variables',
      description: 'Swap two numbers without temp',
      code: '''#include <stdio.h>

int main() {
    int a = 10, b = 20;
    
    printf("Before swap: a = %d, b = %d\\n", a, b);
    
    // Swap without temp
    a = a + b;
    b = a - b;
    a = a - b;
    
    printf("After swap: a = %d, b = %d", a, b);
    
    return 0;
}''',
      output: '''Before swap: a = 10, b = 20
After swap: a = 20, b = 10''',
    ),
    
    ProgramData(
      name: 'Pointer Basics',
      description: 'Understanding pointers in C',
      code: '''#include <stdio.h>

int main() {
    int var = 50;
    int *ptr;
    
    ptr = &var;
    
    printf("Value of var: %d\\n", var);
    printf("Address of var: %p\\n", &var);
    printf("Value of ptr: %p\\n", ptr);
    printf("Value at *ptr: %d\\n", *ptr);
    
    return 0;
}''',
      output: '''Value of var: 50
Address of var: 0x7ffd5c7e4a4c
Value of ptr: 0x7ffd5c7e4a4c
Value at *ptr: 50''',
    ),
  ];
}
