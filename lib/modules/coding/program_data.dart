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
    
    ProgramData(
      name: 'GCD & LCM',
      description: 'Find GCD and LCM of two numbers',
      code: '''#include <stdio.h>

int main() {
    int a = 12, b = 18, gcd, lcm;
    int n1 = a, n2 = b;
    
    // Find GCD
    while (n2 != 0) {
        int temp = n2;
        n2 = n1 % n2;
        n1 = temp;
    }
    gcd = n1;
    
    // Calculate LCM
    lcm = (a * b) / gcd;
    
    printf("GCD of %d and %d = %d\\n", a, b, gcd);
    printf("LCM of %d and %d = %d", a, b, lcm);
    
    return 0;
}''',
      output: '''GCD of 12 and 18 = 6
LCM of 12 and 18 = 36''',
    ),
    
    ProgramData(
      name: 'String Reverse',
      description: 'Reverse a string',
      code: '''#include <stdio.h>
#include <string.h>

int main() {
    char str[] = "Hello";
    int len = strlen(str);
    
    printf("Original: %s\\n", str);
    
    for (int i = 0; i < len/2; i++) {
        char temp = str[i];
        str[i] = str[len-i-1];
        str[len-i-1] = temp;
    }
    
    printf("Reversed: %s", str);
    
    return 0;
}''',
      output: '''Original: Hello
Reversed: olleH''',
    ),
    
    ProgramData(
      name: 'Binary Search',
      description: 'Search element in sorted array',
      code: '''#include <stdio.h>

int main() {
    int arr[] = {2, 5, 8, 12, 16, 23, 38, 45, 56, 67, 78};
    int n = 11, search = 23;
    int left = 0, right = n - 1, found = 0;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        if (arr[mid] == search) {
            printf("Element %d found at index %d", search, mid);
            found = 1;
            break;
        }
        
        if (arr[mid] < search)
            left = mid + 1;
        else
            right = mid - 1;
    }
    
    if (!found)
        printf("Element not found");
    
    return 0;
}''',
      output: 'Element 23 found at index 5',
    ),
    
    ProgramData(
      name: 'Sum of Digits',
      description: 'Calculate sum of digits',
      code: '''#include <stdio.h>

int main() {
    int num = 12345, sum = 0, digit;
    
    printf("Number: %d\\n", num);
    
    while (num > 0) {
        digit = num % 10;
        sum += digit;
        num /= 10;
    }
    
    printf("Sum of digits: %d", sum);
    
    return 0;
}''',
      output: '''Number: 12345
Sum of digits: 15''',
    ),
    
    ProgramData(
      name: 'Power Function',
      description: 'Calculate power using recursion',
      code: '''#include <stdio.h>

int power(int base, int exp) {
    if (exp == 0)
        return 1;
    return base * power(base, exp - 1);
}

int main() {
    int base = 2, exp = 5;
    
    printf("%d^%d = %d", base, exp, power(base, exp));
    
    return 0;
}''',
      output: '2^5 = 32',
    ),
    
    ProgramData(
      name: 'Array Sum & Average',
      description: 'Calculate sum and average of array',
      code: '''#include <stdio.h>

int main() {
    int arr[] = {10, 20, 30, 40, 50};
    int n = 5, sum = 0;
    float avg;
    
    for (int i = 0; i < n; i++) {
        sum += arr[i];
    }
    
    avg = (float)sum / n;
    
    printf("Array: ");
    for (int i = 0; i < n; i++)
        printf("%d ", arr[i]);
    
    printf("\\nSum: %d\\n", sum);
    printf("Average: %.2f", avg);
    
    return 0;
}''',
      output: '''Array: 10 20 30 40 50
Sum: 150
Average: 30.00''',
    ),
    
    ProgramData(
      name: 'Largest Element',
      description: 'Find largest element in array',
      code: '''#include <stdio.h>

int main() {
    int arr[] = {34, 78, 12, 90, 45, 23};
    int n = 6, max;
    
    max = arr[0];
    
    for (int i = 1; i < n; i++) {
        if (arr[i] > max)
            max = arr[i];
    }
    
    printf("Array: ");
    for (int i = 0; i < n; i++)
        printf("%d ", arr[i]);
    
    printf("\\nLargest element: %d", max);
    
    return 0;
}''',
      output: '''Array: 34 78 12 90 45 23
Largest element: 90''',
    ),
    
    ProgramData(
      name: 'Linear Search',
      description: 'Search element in array',
      code: '''#include <stdio.h>

int main() {
    int arr[] = {10, 23, 45, 70, 11, 15};
    int n = 6, search = 70, found = 0;
    
    for (int i = 0; i < n; i++) {
        if (arr[i] == search) {
            printf("Element %d found at index %d", search, i);
            found = 1;
            break;
        }
    }
    
    if (!found)
        printf("Element not found");
    
    return 0;
}''',
      output: 'Element 70 found at index 3',
    ),
    
    ProgramData(
      name: 'Selection Sort',
      description: 'Sort array using selection sort',
      code: '''#include <stdio.h>

int main() {
    int arr[] = {64, 25, 12, 22, 11};
    int n = 5;
    
    printf("Original: ");
    for (int i = 0; i < n; i++)
        printf("%d ", arr[i]);
    
    // Selection sort
    for (int i = 0; i < n-1; i++) {
        int min_idx = i;
        for (int j = i+1; j < n; j++) {
            if (arr[j] < arr[min_idx])
                min_idx = j;
        }
        int temp = arr[min_idx];
        arr[min_idx] = arr[i];
        arr[i] = temp;
    }
    
    printf("\\nSorted: ");
    for (int i = 0; i < n; i++)
        printf("%d ", arr[i]);
    
    return 0;
}''',
      output: '''Original: 64 25 12 22 11
Sorted: 11 12 22 25 64''',
    ),
    
    ProgramData(
      name: 'Insertion Sort',
      description: 'Sort using insertion sort',
      code: '''#include <stdio.h>

int main() {
    int arr[] = {12, 11, 13, 5, 6};
    int n = 5;
    
    printf("Original: ");
    for (int i = 0; i < n; i++)
        printf("%d ", arr[i]);
    
    // Insertion sort
    for (int i = 1; i < n; i++) {
        int key = arr[i];
        int j = i - 1;
        
        while (j >= 0 && arr[j] > key) {
            arr[j + 1] = arr[j];
            j = j - 1;
        }
        arr[j + 1] = key;
    }
    
    printf("\\nSorted: ");
    for (int i = 0; i < n; i++)
        printf("%d ", arr[i]);
    
    return 0;
}''',
      output: '''Original: 12 11 13 5 6
Sorted: 5 6 11 12 13''',
    ),
    
    ProgramData(
      name: 'Matrix Addition',
      description: 'Add two matrices',
      code: '''#include <stdio.h>

int main() {
    int a[2][2] = {{1, 2}, {3, 4}};
    int b[2][2] = {{5, 6}, {7, 8}};
    int sum[2][2];
    
    // Add matrices
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            sum[i][j] = a[i][j] + b[i][j];
        }
    }
    
    printf("Sum:\\n");
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            printf("%d ", sum[i][j]);
        }
        printf("\\n");
    }
    
    return 0;
}''',
      output: '''Sum:
6 8
10 12''',
    ),
    
    ProgramData(
      name: 'Matrix Transpose',
      description: 'Transpose a matrix',
      code: '''#include <stdio.h>

int main() {
    int matrix[3][2] = {{1, 2}, {3, 4}, {5, 6}};
    int transpose[2][3];
    
    // Transpose
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 2; j++) {
            transpose[j][i] = matrix[i][j];
        }
    }
    
    printf("Original:\\n");
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 2; j++)
            printf("%d ", matrix[i][j]);
        printf("\\n");
    }
    
    printf("\\nTranspose:\\n");
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++)
            printf("%d ", transpose[i][j]);
        printf("\\n");
    }
    
    return 0;
}''',
      output: '''Original:
1 2
3 4
5 6

Transpose:
1 3 5
2 4 6''',
    ),
    
    ProgramData(
      name: 'String Length',
      description: 'Calculate string length without strlen',
      code: '''#include <stdio.h>

int main() {
    char str[] = "Programming";
    int length = 0;
    
    while (str[length] != '\\0') {
        length++;
    }
    
    printf("String: %s\\n", str);
    printf("Length: %d", length);
    
    return 0;
}''',
      output: '''String: Programming
Length: 11''',
    ),
    
    ProgramData(
      name: 'String Concatenation',
      description: 'Concatenate two strings',
      code: '''#include <stdio.h>

int main() {
    char str1[50] = "Hello ";
    char str2[] = "World";
    int i = 0, j = 0;
    
    // Find end of str1
    while (str1[i] != '\\0')
        i++;
    
    // Copy str2 to end of str1
    while (str2[j] != '\\0') {
        str1[i] = str2[j];
        i++;
        j++;
    }
    str1[i] = '\\0';
    
    printf("Result: %s", str1);
    
    return 0;
}''',
      output: 'Result: Hello World',
    ),
    
    ProgramData(
      name: 'String Compare',
      description: 'Compare two strings',
      code: '''#include <stdio.h>

int main() {
    char str1[] = "Hello";
    char str2[] = "Hello";
    int i = 0, equal = 1;
    
    while (str1[i] != '\\0' || str2[i] != '\\0') {
        if (str1[i] != str2[i]) {
            equal = 0;
            break;
        }
        i++;
    }
    
    if (equal)
        printf("Strings are equal");
    else
        printf("Strings are not equal");
    
    return 0;
}''',
      output: 'Strings are equal',
    ),
    
    ProgramData(
      name: 'Vowel Counter',
      description: 'Count vowels in a string',
      code: '''#include <stdio.h>
#include <ctype.h>

int main() {
    char str[] = "Hello World";
    int vowels = 0;
    
    for (int i = 0; str[i] != '\\0'; i++) {
        char ch = tolower(str[i]);
        if (ch == 'a' || ch == 'e' || ch == 'i' || 
            ch == 'o' || ch == 'u') {
            vowels++;
        }
    }
    
    printf("String: %s\\n", str);
    printf("Vowels: %d", vowels);
    
    return 0;
}''',
      output: '''String: Hello World
Vowels: 3''',
    ),
    
    ProgramData(
      name: 'Decimal to Binary',
      description: 'Convert decimal to binary',
      code: '''#include <stdio.h>

int main() {
    int num = 10, binary[32], i = 0;
    
    printf("Decimal: %d\\n", num);
    
    while (num > 0) {
        binary[i] = num % 2;
        num = num / 2;
        i++;
    }
    
    printf("Binary: ");
    for (int j = i - 1; j >= 0; j--)
        printf("%d", binary[j]);
    
    return 0;
}''',
      output: '''Decimal: 10
Binary: 1010''',
    ),
    
    ProgramData(
      name: 'Binary to Decimal',
      description: 'Convert binary to decimal',
      code: '''#include <stdio.h>
#include <math.h>

int main() {
    long long binary = 1010;
    int decimal = 0, i = 0, remainder;
    
    printf("Binary: %lld\\n", binary);
    
    while (binary != 0) {
        remainder = binary % 10;
        binary /= 10;
        decimal += remainder * pow(2, i);
        ++i;
    }
    
    printf("Decimal: %d", decimal);
    
    return 0;
}''',
      output: '''Binary: 1010
Decimal: 10''',
    ),
    
    ProgramData(
      name: 'Tower of Hanoi',
      description: 'Solve Tower of Hanoi puzzle',
      code: '''#include <stdio.h>

void hanoi(int n, char from, char to, char aux) {
    if (n == 1) {
        printf("Move disk 1 from %c to %c\\n", from, to);
        return;
    }
    hanoi(n-1, from, aux, to);
    printf("Move disk %d from %c to %c\\n", n, from, to);
    hanoi(n-1, aux, to, from);
}

int main() {
    int n = 3;
    printf("Tower of Hanoi for %d disks:\\n", n);
    hanoi(n, 'A', 'C', 'B');
    return 0;
}''',
      output: '''Tower of Hanoi for 3 disks:
Move disk 1 from A to C
Move disk 2 from A to B
Move disk 1 from C to B
Move disk 3 from A to C
Move disk 1 from B to A
Move disk 2 from B to C
Move disk 1 from A to C''',
    ),
    
    ProgramData(
      name: 'Perfect Number',
      description: 'Check if number is perfect',
      code: '''#include <stdio.h>

int main() {
    int num = 28, sum = 0;
    
    printf("Number: %d\\n", num);
    
    for (int i = 1; i < num; i++) {
        if (num % i == 0)
            sum += i;
    }
    
    if (sum == num)
        printf("%d is a perfect number", num);
    else
        printf("%d is not a perfect number", num);
    
    return 0;
}''',
      output: '''Number: 28
28 is a perfect number''',
    ),
    
    ProgramData(
      name: 'Strong Number',
      description: 'Check if number is strong',
      code: '''#include <stdio.h>

int factorial(int n) {
    if (n == 0 || n == 1)
        return 1;
    return n * factorial(n - 1);
}

int main() {
    int num = 145, sum = 0, temp, digit;
    
    temp = num;
    
    while (temp > 0) {
        digit = temp % 10;
        sum += factorial(digit);
        temp /= 10;
    }
    
    if (sum == num)
        printf("%d is a strong number", num);
    else
        printf("%d is not a strong number", num);
    
    return 0;
}''',
      output: '145 is a strong number',
    ),
    
    ProgramData(
      name: 'Leap Year Check',
      description: 'Check if year is leap year',
      code: '''#include <stdio.h>

int main() {
    int year = 2024;
    
    if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0))
        printf("%d is a leap year", year);
    else
        printf("%d is not a leap year", year);
    
    return 0;
}''',
      output: '2024 is a leap year',
    ),
  ];
}

