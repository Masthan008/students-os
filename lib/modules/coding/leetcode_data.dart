import 'leetcode_problem.dart';

class LeetCodeRepository {
  static final List<LeetCodeProblem> allProblems = [
    // Problem 1: Two Sum
    LeetCodeProblem(
      id: 1,
      title: 'Two Sum',
      difficulty: 'Easy',
      description: '''Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

You can return the answer in any order.''',
      examples: [
        '''Input: nums = [2,7,11,15], target = 9
Output: [0,1]
Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].''',
        '''Input: nums = [3,2,4], target = 6
Output: [1,2]''',
        '''Input: nums = [3,3], target = 6
Output: [0,1]''',
      ],
      testCases: [
        'nums = [2,7,11,15], target = 9 → [0,1]',
        'nums = [3,2,4], target = 6 → [1,2]',
        'nums = [3,3], target = 6 → [0,1]',
      ],
      constraints: '''• 2 <= nums.length <= 10^4
• -10^9 <= nums[i] <= 10^9
• -10^9 <= target <= 10^9
• Only one valid answer exists.''',
      solution: '''#include <stdio.h>
#include <stdlib.h>

int* twoSum(int* nums, int numsSize, int target, int* returnSize) {
    int* result = (int*)malloc(2 * sizeof(int));
    *returnSize = 2;
    
    for (int i = 0; i < numsSize; i++) {
        for (int j = i + 1; j < numsSize; j++) {
            if (nums[i] + nums[j] == target) {
                result[0] = i;
                result[1] = j;
                return result;
            }
        }
    }
    
    return result;
}

int main() {
    int nums[] = {2, 7, 11, 15};
    int target = 9;
    int returnSize;
    
    int* result = twoSum(nums, 4, target, &returnSize);
    
    printf("[%d, %d]\\n", result[0], result[1]);
    
    free(result);
    return 0;
}''',
      explanation: '''**Approach: Brute Force**

1. Use two nested loops to check all pairs
2. For each element, check if it adds with any other element to equal target
3. Return the indices when found

**Time Complexity:** O(n²)
**Space Complexity:** O(1)

**Better Approach:** Use hash table for O(n) time complexity''',
      topics: ['Array', 'Hash Table'],
    ),

    // Problem 2: Reverse Integer
    LeetCodeProblem(
      id: 7,
      title: 'Reverse Integer',
      difficulty: 'Medium',
      description: '''Given a signed 32-bit integer x, return x with its digits reversed. If reversing x causes the value to go outside the signed 32-bit integer range [-2^31, 2^31 - 1], then return 0.

Assume the environment does not allow you to store 64-bit integers (signed or unsigned).''',
      examples: [
        '''Input: x = 123
Output: 321''',
        '''Input: x = -123
Output: -321''',
        '''Input: x = 120
Output: 21''',
      ],
      testCases: [
        'x = 123 → 321',
        'x = -123 → -321',
        'x = 120 → 21',
        'x = 0 → 0',
      ],
      constraints: '''• -2^31 <= x <= 2^31 - 1''',
      solution: '''#include <stdio.h>
#include <limits.h>

int reverse(int x) {
    int rev = 0;
    
    while (x != 0) {
        int digit = x % 10;
        x /= 10;
        
        // Check for overflow before multiplying
        if (rev > INT_MAX/10 || (rev == INT_MAX/10 && digit > 7)) 
            return 0;
        if (rev < INT_MIN/10 || (rev == INT_MIN/10 && digit < -8)) 
            return 0;
        
        rev = rev * 10 + digit;
    }
    
    return rev;
}

int main() {
    printf("%d\\n", reverse(123));    // 321
    printf("%d\\n", reverse(-123));   // -321
    printf("%d\\n", reverse(120));    // 21
    return 0;
}''',
      explanation: '''**Approach:**

1. Extract last digit using modulo (%)
2. Build reversed number by multiplying by 10 and adding digit
3. Check for overflow before each operation
4. Handle negative numbers automatically

**Time Complexity:** O(log n) - number of digits
**Space Complexity:** O(1)''',
      topics: ['Math'],
    ),

    // Problem 3: Palindrome Number
    LeetCodeProblem(
      id: 9,
      title: 'Palindrome Number',
      difficulty: 'Easy',
      description: '''Given an integer x, return true if x is a palindrome, and false otherwise.

An integer is a palindrome when it reads the same forward and backward.

For example, 121 is a palindrome while 123 is not.''',
      examples: [
        '''Input: x = 121
Output: true
Explanation: 121 reads as 121 from left to right and from right to left.''',
        '''Input: x = -121
Output: false
Explanation: From left to right, it reads -121. From right to left, it becomes 121-. Therefore it is not a palindrome.''',
        '''Input: x = 10
Output: false
Explanation: Reads 01 from right to left. Therefore it is not a palindrome.''',
      ],
      testCases: [
        'x = 121 → true',
        'x = -121 → false',
        'x = 10 → false',
        'x = 0 → true',
      ],
      constraints: '''• -2^31 <= x <= 2^31 - 1''',
      solution: '''#include <stdio.h>
#include <stdbool.h>

bool isPalindrome(int x) {
    // Negative numbers are not palindromes
    if (x < 0) return false;
    
    // Numbers ending in 0 (except 0 itself) are not palindromes
    if (x != 0 && x % 10 == 0) return false;
    
    int reversed = 0;
    int original = x;
    
    while (x > 0) {
        reversed = reversed * 10 + x % 10;
        x /= 10;
    }
    
    return original == reversed;
}

int main() {
    printf("%d\\n", isPalindrome(121));   // 1 (true)
    printf("%d\\n", isPalindrome(-121));  // 0 (false)
    printf("%d\\n", isPalindrome(10));    // 0 (false)
    return 0;
}''',
      explanation: '''**Approach:**

1. Handle edge cases: negative numbers and numbers ending in 0
2. Reverse the number
3. Compare with original

**Optimization:** Only reverse half the number to save time

**Time Complexity:** O(log n)
**Space Complexity:** O(1)''',
      topics: ['Math'],
    ),

    // Problem 4: Roman to Integer
    LeetCodeProblem(
      id: 13,
      title: 'Roman to Integer',
      difficulty: 'Easy',
      description: '''Roman numerals are represented by seven different symbols: I, V, X, L, C, D and M.

Symbol       Value
I             1
V             5
X             10
L             50
C             100
D             500
M             1000

Given a roman numeral, convert it to an integer.''',
      examples: [
        '''Input: s = "III"
Output: 3
Explanation: III = 3.''',
        '''Input: s = "LVIII"
Output: 58
Explanation: L = 50, V= 5, III = 3.''',
        '''Input: s = "MCMXCIV"
Output: 1994
Explanation: M = 1000, CM = 900, XC = 90 and IV = 4.''',
      ],
      testCases: [
        's = "III" → 3',
        's = "LVIII" → 58',
        's = "MCMXCIV" → 1994',
      ],
      constraints: '''• 1 <= s.length <= 15
• s contains only the characters ('I', 'V', 'X', 'L', 'C', 'D', 'M').
• It is guaranteed that s is a valid roman numeral in the range [1, 3999].''',
      solution: '''#include <stdio.h>
#include <string.h>

int getValue(char c) {
    switch(c) {
        case 'I': return 1;
        case 'V': return 5;
        case 'X': return 10;
        case 'L': return 50;
        case 'C': return 100;
        case 'D': return 500;
        case 'M': return 1000;
        default: return 0;
    }
}

int romanToInt(char* s) {
    int result = 0;
    int len = strlen(s);
    
    for (int i = 0; i < len; i++) {
        int current = getValue(s[i]);
        int next = (i + 1 < len) ? getValue(s[i + 1]) : 0;
        
        if (current < next) {
            result -= current;
        } else {
            result += current;
        }
    }
    
    return result;
}

int main() {
    printf("%d\\n", romanToInt("III"));      // 3
    printf("%d\\n", romanToInt("LVIII"));    // 58
    printf("%d\\n", romanToInt("MCMXCIV"));  // 1994
    return 0;
}''',
      explanation: '''**Approach:**

1. Create helper function to get value of each Roman character
2. Iterate through string
3. If current value < next value, subtract (e.g., IV = 4)
4. Otherwise, add the value

**Key Insight:** In Roman numerals, smaller value before larger means subtraction

**Time Complexity:** O(n)
**Space Complexity:** O(1)''',
      topics: ['Hash Table', 'Math', 'String'],
    ),

    // Problem 5: Valid Parentheses
    LeetCodeProblem(
      id: 20,
      title: 'Valid Parentheses',
      difficulty: 'Easy',
      description: '''Given a string s containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid.

An input string is valid if:
1. Open brackets must be closed by the same type of brackets.
2. Open brackets must be closed in the correct order.
3. Every close bracket has a corresponding open bracket of the same type.''',
      examples: [
        '''Input: s = "()"
Output: true''',
        '''Input: s = "()[]{}"
Output: true''',
        '''Input: s = "(]"
Output: false''',
      ],
      testCases: [
        's = "()" → true',
        's = "()[]{}" → true',
        's = "(]" → false',
        's = "([)]" → false',
        's = "{[]}" → true',
      ],
      constraints: '''• 1 <= s.length <= 10^4
• s consists of parentheses only '()[]{}'.''',
      solution: '''#include <stdio.h>
#include <string.h>
#include <stdbool.h>

bool isValid(char* s) {
    char stack[10000];
    int top = -1;
    int len = strlen(s);
    
    for (int i = 0; i < len; i++) {
        char c = s[i];
        
        // Push opening brackets
        if (c == '(' || c == '{' || c == '[') {
            stack[++top] = c;
        }
        // Check closing brackets
        else {
            if (top == -1) return false;
            
            char last = stack[top--];
            
            if ((c == ')' && last != '(') ||
                (c == '}' && last != '{') ||
                (c == ']' && last != '[')) {
                return false;
            }
        }
    }
    
    return top == -1;
}

int main() {
    printf("%d\\n", isValid("()"));       // 1 (true)
    printf("%d\\n", isValid("()[]{}"));   // 1 (true)
    printf("%d\\n", isValid("(]"));       // 0 (false)
    return 0;
}''',
      explanation: '''**Approach: Stack**

1. Use stack to track opening brackets
2. When opening bracket found, push to stack
3. When closing bracket found, check if it matches top of stack
4. At end, stack should be empty

**Time Complexity:** O(n)
**Space Complexity:** O(n)''',
      topics: ['String', 'Stack'],
    ),

    // Problem 6: Merge Two Sorted Lists
    LeetCodeProblem(
      id: 21,
      title: 'Merge Two Sorted Lists',
      difficulty: 'Easy',
      description: '''You are given the heads of two sorted linked lists list1 and list2.

Merge the two lists into one sorted list. The list should be made by splicing together the nodes of the first two lists.

Return the head of the merged linked list.''',
      examples: [
        '''Input: list1 = [1,2,4], list2 = [1,3,4]
Output: [1,1,2,3,4,4]''',
        '''Input: list1 = [], list2 = []
Output: []''',
        '''Input: list1 = [], list2 = [0]
Output: [0]''',
      ],
      testCases: [
        'list1 = [1,2,4], list2 = [1,3,4] → [1,1,2,3,4,4]',
        'list1 = [], list2 = [] → []',
        'list1 = [], list2 = [0] → [0]',
      ],
      constraints: '''• The number of nodes in both lists is in the range [0, 50].
• -100 <= Node.val <= 100
• Both list1 and list2 are sorted in non-decreasing order.''',
      solution: '''#include <stdio.h>
#include <stdlib.h>

struct ListNode {
    int val;
    struct ListNode *next;
};

struct ListNode* mergeTwoLists(struct ListNode* list1, struct ListNode* list2) {
    // Create dummy node
    struct ListNode dummy;
    struct ListNode* tail = &dummy;
    dummy.next = NULL;
    
    while (list1 != NULL && list2 != NULL) {
        if (list1->val <= list2->val) {
            tail->next = list1;
            list1 = list1->next;
        } else {
            tail->next = list2;
            list2 = list2->next;
        }
        tail = tail->next;
    }
    
    // Attach remaining nodes
    tail->next = (list1 != NULL) ? list1 : list2;
    
    return dummy.next;
}

int main() {
    // Example usage
    printf("Merge two sorted linked lists\\n");
    return 0;
}''',
      explanation: '''**Approach: Two Pointers**

1. Create dummy node to simplify edge cases
2. Compare values from both lists
3. Attach smaller value to result
4. Move pointer forward
5. Attach remaining nodes

**Time Complexity:** O(n + m)
**Space Complexity:** O(1)''',
      topics: ['Linked List', 'Recursion'],
    ),

    // Problem 7: Remove Duplicates from Sorted Array
    LeetCodeProblem(
      id: 26,
      title: 'Remove Duplicates from Sorted Array',
      difficulty: 'Easy',
      description: '''Given an integer array nums sorted in non-decreasing order, remove the duplicates in-place such that each unique element appears only once. The relative order of the elements should be kept the same.

Return k after placing the final result in the first k slots of nums.''',
      examples: [
        '''Input: nums = [1,1,2]
Output: 2, nums = [1,2,_]
Explanation: Your function should return k = 2, with the first two elements of nums being 1 and 2 respectively.''',
        '''Input: nums = [0,0,1,1,1,2,2,3,3,4]
Output: 5, nums = [0,1,2,3,4,_,_,_,_,_]''',
      ],
      testCases: [
        'nums = [1,1,2] → 2',
        'nums = [0,0,1,1,1,2,2,3,3,4] → 5',
      ],
      constraints: '''• 1 <= nums.length <= 3 * 10^4
• -100 <= nums[i] <= 100
• nums is sorted in non-decreasing order.''',
      solution: '''#include <stdio.h>

int removeDuplicates(int* nums, int numsSize) {
    if (numsSize == 0) return 0;
    
    int k = 1; // Position for next unique element
    
    for (int i = 1; i < numsSize; i++) {
        if (nums[i] != nums[i-1]) {
            nums[k] = nums[i];
            k++;
        }
    }
    
    return k;
}

int main() {
    int nums1[] = {1, 1, 2};
    int k1 = removeDuplicates(nums1, 3);
    printf("k = %d, nums = [", k1);
    for (int i = 0; i < k1; i++) {
        printf("%d%s", nums1[i], i < k1-1 ? "," : "");
    }
    printf("]\\n");
    
    return 0;
}''',
      explanation: '''**Approach: Two Pointers**

1. Use k to track position for next unique element
2. Compare each element with previous
3. If different, place at position k and increment k
4. Return k as count of unique elements

**Time Complexity:** O(n)
**Space Complexity:** O(1)''',
      topics: ['Array', 'Two Pointers'],
    ),

    // Problem 8: Search Insert Position
    LeetCodeProblem(
      id: 35,
      title: 'Search Insert Position',
      difficulty: 'Easy',
      description: '''Given a sorted array of distinct integers and a target value, return the index if the target is found. If not, return the index where it would be if it were inserted in order.

You must write an algorithm with O(log n) runtime complexity.''',
      examples: [
        '''Input: nums = [1,3,5,6], target = 5
Output: 2''',
        '''Input: nums = [1,3,5,6], target = 2
Output: 1''',
        '''Input: nums = [1,3,5,6], target = 7
Output: 4''',
      ],
      testCases: [
        'nums = [1,3,5,6], target = 5 → 2',
        'nums = [1,3,5,6], target = 2 → 1',
        'nums = [1,3,5,6], target = 7 → 4',
      ],
      constraints: '''• 1 <= nums.length <= 10^4
• -10^4 <= nums[i] <= 10^4
• nums contains distinct values sorted in ascending order.
• -10^4 <= target <= 10^4''',
      solution: '''#include <stdio.h>

int searchInsert(int* nums, int numsSize, int target) {
    int left = 0;
    int right = numsSize - 1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        if (nums[mid] == target) {
            return mid;
        } else if (nums[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    
    return left;
}

int main() {
    int nums[] = {1, 3, 5, 6};
    printf("%d\\n", searchInsert(nums, 4, 5));  // 2
    printf("%d\\n", searchInsert(nums, 4, 2));  // 1
    printf("%d\\n", searchInsert(nums, 4, 7));  // 4
    return 0;
}''',
      explanation: '''**Approach: Binary Search**

1. Use binary search to find target
2. If found, return index
3. If not found, left pointer will be at insert position
4. Return left

**Time Complexity:** O(log n)
**Space Complexity:** O(1)''',
      topics: ['Array', 'Binary Search'],
    ),

    // Problem 9: Maximum Subarray
    LeetCodeProblem(
      id: 53,
      title: 'Maximum Subarray',
      difficulty: 'Medium',
      description: '''Given an integer array nums, find the subarray with the largest sum, and return its sum.

A subarray is a contiguous non-empty sequence of elements within an array.''',
      examples: [
        '''Input: nums = [-2,1,-3,4,-1,2,1,-5,4]
Output: 6
Explanation: The subarray [4,-1,2,1] has the largest sum 6.''',
        '''Input: nums = [1]
Output: 1
Explanation: The subarray [1] has the largest sum 1.''',
        '''Input: nums = [5,4,-1,7,8]
Output: 23
Explanation: The subarray [5,4,-1,7,8] has the largest sum 23.''',
      ],
      testCases: [
        'nums = [-2,1,-3,4,-1,2,1,-5,4] → 6',
        'nums = [1] → 1',
        'nums = [5,4,-1,7,8] → 23',
      ],
      constraints: '''• 1 <= nums.length <= 10^5
• -10^4 <= nums[i] <= 10^4''',
      solution: '''#include <stdio.h>

int maxSubArray(int* nums, int numsSize) {
    int maxSum = nums[0];
    int currentSum = nums[0];
    
    for (int i = 1; i < numsSize; i++) {
        // Either extend current subarray or start new one
        currentSum = (nums[i] > currentSum + nums[i]) ? nums[i] : currentSum + nums[i];
        
        // Update maximum
        if (currentSum > maxSum) {
            maxSum = currentSum;
        }
    }
    
    return maxSum;
}

int main() {
    int nums1[] = {-2,1,-3,4,-1,2,1,-5,4};
    printf("%d\\n", maxSubArray(nums1, 9));  // 6
    
    int nums2[] = {5,4,-1,7,8};
    printf("%d\\n", maxSubArray(nums2, 5));  // 23
    
    return 0;
}''',
      explanation: '''**Approach: Kadane's Algorithm**

1. Track current sum and maximum sum
2. At each position, decide: extend current subarray or start new
3. Update maximum if current sum is larger

**Key Insight:** If current sum becomes negative, start fresh

**Time Complexity:** O(n)
**Space Complexity:** O(1)''',
      topics: ['Array', 'Dynamic Programming', 'Divide and Conquer'],
    ),

    // Problem 10: Plus One
    LeetCodeProblem(
      id: 66,
      title: 'Plus One',
      difficulty: 'Easy',
      description: '''You are given a large integer represented as an integer array digits, where each digits[i] is the ith digit of the integer. The digits are ordered from most significant to least significant in left-to-right order. The large integer does not contain any leading 0's.

Increment the large integer by one and return the resulting array of digits.''',
      examples: [
        '''Input: digits = [1,2,3]
Output: [1,2,4]
Explanation: The array represents the integer 123. Incrementing by one gives 123 + 1 = 124.''',
        '''Input: digits = [4,3,2,1]
Output: [4,3,2,2]''',
        '''Input: digits = [9]
Output: [1,0]''',
      ],
      testCases: [
        'digits = [1,2,3] → [1,2,4]',
        'digits = [4,3,2,1] → [4,3,2,2]',
        'digits = [9] → [1,0]',
        'digits = [9,9,9] → [1,0,0,0]',
      ],
      constraints: '''• 1 <= digits.length <= 100
• 0 <= digits[i] <= 9
• digits does not contain any leading 0's.''',
      solution: '''#include <stdio.h>
#include <stdlib.h>

int* plusOne(int* digits, int digitsSize, int* returnSize) {
    // Try to add 1 from right to left
    for (int i = digitsSize - 1; i >= 0; i--) {
        if (digits[i] < 9) {
            digits[i]++;
            *returnSize = digitsSize;
            return digits;
        }
        digits[i] = 0;
    }
    
    // All digits were 9, need extra digit
    int* result = (int*)malloc((digitsSize + 1) * sizeof(int));
    result[0] = 1;
    for (int i = 1; i <= digitsSize; i++) {
        result[i] = 0;
    }
    *returnSize = digitsSize + 1;
    return result;
}

int main() {
    int digits1[] = {1, 2, 3};
    int returnSize;
    int* result = plusOne(digits1, 3, &returnSize);
    
    printf("[");
    for (int i = 0; i < returnSize; i++) {
        printf("%d%s", result[i], i < returnSize-1 ? "," : "");
    }
    printf("]\\n");
    
    return 0;
}''',
      explanation: '''**Approach:**

1. Start from rightmost digit
2. If digit < 9, increment and return
3. If digit = 9, set to 0 and continue (carry)
4. If all digits were 9, create new array with 1 followed by zeros

**Time Complexity:** O(n)
**Space Complexity:** O(1) or O(n) if all 9s''',
      topics: ['Array', 'Math'],
    ),
  ];
}
