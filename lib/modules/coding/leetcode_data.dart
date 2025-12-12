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

    // Problem 11: Climbing Stairs
    LeetCodeProblem(
      id: 70,
      title: 'Climbing Stairs',
      difficulty: 'Easy',
      description: '''You are climbing a staircase. It takes n steps to reach the top.

Each time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?''',
      examples: [
        '''Input: n = 2
Output: 2
Explanation: There are two ways to climb to the top.
1. 1 step + 1 step
2. 2 steps''',
        '''Input: n = 3
Output: 3
Explanation: There are three ways to climb to the top.
1. 1 step + 1 step + 1 step
2. 1 step + 2 steps
3. 2 steps + 1 step''',
      ],
      testCases: [
        'n = 2 → 2',
        'n = 3 → 3',
        'n = 5 → 8',
      ],
      constraints: '''• 1 <= n <= 45''',
      solution: '''#include <stdio.h>

int climbStairs(int n) {
    if (n <= 2) return n;
    
    int prev2 = 1;  // ways to reach step 1
    int prev1 = 2;  // ways to reach step 2
    int current;
    
    for (int i = 3; i <= n; i++) {
        current = prev1 + prev2;
        prev2 = prev1;
        prev1 = current;
    }
    
    return current;
}

int main() {
    printf("%d\\n", climbStairs(2));  // 2
    printf("%d\\n", climbStairs(3));  // 3
    printf("%d\\n", climbStairs(5));  // 8
    return 0;
}''',
      explanation: '''**Approach: Dynamic Programming (Fibonacci Pattern)**

1. Base cases: 1 step = 1 way, 2 steps = 2 ways
2. For each step, ways = ways(n-1) + ways(n-2)
3. Use two variables to save space

**Pattern:** This is Fibonacci sequence!

**Time Complexity:** O(n)
**Space Complexity:** O(1)''',
      topics: ['Dynamic Programming', 'Math', 'Memoization'],
    ),

    // Problem 12: Best Time to Buy and Sell Stock
    LeetCodeProblem(
      id: 121,
      title: 'Best Time to Buy and Sell Stock',
      difficulty: 'Easy',
      description: '''You are given an array prices where prices[i] is the price of a given stock on the ith day.

You want to maximize your profit by choosing a single day to buy one stock and choosing a different day in the future to sell that stock.

Return the maximum profit you can achieve from this transaction. If you cannot achieve any profit, return 0.''',
      examples: [
        '''Input: prices = [7,1,5,3,6,4]
Output: 5
Explanation: Buy on day 2 (price = 1) and sell on day 5 (price = 6), profit = 6-1 = 5.''',
        '''Input: prices = [7,6,4,3,1]
Output: 0
Explanation: No profit possible.''',
      ],
      testCases: [
        'prices = [7,1,5,3,6,4] → 5',
        'prices = [7,6,4,3,1] → 0',
        'prices = [2,4,1] → 2',
      ],
      constraints: '''• 1 <= prices.length <= 10^5
• 0 <= prices[i] <= 10^4''',
      solution: '''#include <stdio.h>

int maxProfit(int* prices, int pricesSize) {
    if (pricesSize < 2) return 0;
    
    int minPrice = prices[0];
    int maxProfit = 0;
    
    for (int i = 1; i < pricesSize; i++) {
        // Update minimum price seen so far
        if (prices[i] < minPrice) {
            minPrice = prices[i];
        }
        
        // Calculate profit if we sell today
        int profit = prices[i] - minPrice;
        
        // Update maximum profit
        if (profit > maxProfit) {
            maxProfit = profit;
        }
    }
    
    return maxProfit;
}

int main() {
    int prices1[] = {7,1,5,3,6,4};
    printf("%d\\n", maxProfit(prices1, 6));  // 5
    
    int prices2[] = {7,6,4,3,1};
    printf("%d\\n", maxProfit(prices2, 5));  // 0
    
    return 0;
}''',
      explanation: '''**Approach: One Pass**

1. Track minimum price seen so far
2. Calculate profit if we sell at current price
3. Update maximum profit

**Key Insight:** Buy at lowest, sell at highest after that

**Time Complexity:** O(n)
**Space Complexity:** O(1)''',
      topics: ['Array', 'Dynamic Programming', 'Greedy'],
    ),

    // Problem 13: Single Number
    LeetCodeProblem(
      id: 136,
      title: 'Single Number',
      difficulty: 'Easy',
      description: '''Given a non-empty array of integers nums, every element appears twice except for one. Find that single one.

You must implement a solution with a linear runtime complexity and use only constant extra space.''',
      examples: [
        '''Input: nums = [2,2,1]
Output: 1''',
        '''Input: nums = [4,1,2,1,2]
Output: 4''',
        '''Input: nums = [1]
Output: 1''',
      ],
      testCases: [
        'nums = [2,2,1] → 1',
        'nums = [4,1,2,1,2] → 4',
        'nums = [1] → 1',
      ],
      constraints: '''• 1 <= nums.length <= 3 * 10^4
• -3 * 10^4 <= nums[i] <= 3 * 10^4
• Each element appears twice except for one''',
      solution: '''#include <stdio.h>

int singleNumber(int* nums, int numsSize) {
    int result = 0;
    
    // XOR all numbers
    for (int i = 0; i < numsSize; i++) {
        result ^= nums[i];
    }
    
    return result;
}

int main() {
    int nums1[] = {2,2,1};
    printf("%d\\n", singleNumber(nums1, 3));  // 1
    
    int nums2[] = {4,1,2,1,2};
    printf("%d\\n", singleNumber(nums2, 5));  // 4
    
    return 0;
}''',
      explanation: '''**Approach: XOR Bit Manipulation**

1. XOR all numbers together
2. Duplicates cancel out (a ^ a = 0)
3. Result is the single number

**XOR Properties:**
- a ^ 0 = a
- a ^ a = 0
- XOR is commutative and associative

**Time Complexity:** O(n)
**Space Complexity:** O(1)''',
      topics: ['Array', 'Bit Manipulation'],
    ),

    // Problem 14: Majority Element
    LeetCodeProblem(
      id: 169,
      title: 'Majority Element',
      difficulty: 'Easy',
      description: '''Given an array nums of size n, return the majority element.

The majority element is the element that appears more than ⌊n / 2⌋ times. You may assume that the majority element always exists in the array.''',
      examples: [
        '''Input: nums = [3,2,3]
Output: 3''',
        '''Input: nums = [2,2,1,1,1,2,2]
Output: 2''',
      ],
      testCases: [
        'nums = [3,2,3] → 3',
        'nums = [2,2,1,1,1,2,2] → 2',
        'nums = [1] → 1',
      ],
      constraints: '''• n == nums.length
• 1 <= n <= 5 * 10^4
• -10^9 <= nums[i] <= 10^9''',
      solution: '''#include <stdio.h>

int majorityElement(int* nums, int numsSize) {
    int candidate = nums[0];
    int count = 1;
    
    // Boyer-Moore Voting Algorithm
    for (int i = 1; i < numsSize; i++) {
        if (count == 0) {
            candidate = nums[i];
            count = 1;
        } else if (nums[i] == candidate) {
            count++;
        } else {
            count--;
        }
    }
    
    return candidate;
}

int main() {
    int nums1[] = {3,2,3};
    printf("%d\\n", majorityElement(nums1, 3));  // 3
    
    int nums2[] = {2,2,1,1,1,2,2};
    printf("%d\\n", majorityElement(nums2, 7));  // 2
    
    return 0;
}''',
      explanation: '''**Approach: Boyer-Moore Voting Algorithm**

1. Maintain a candidate and count
2. If count is 0, pick new candidate
3. Increment count if same, decrement if different
4. Majority element survives

**Why it works:** Majority element appears > n/2 times

**Time Complexity:** O(n)
**Space Complexity:** O(1)''',
      topics: ['Array', 'Hash Table', 'Divide and Conquer', 'Sorting', 'Counting'],
    ),

    // Problem 15: Move Zeroes
    LeetCodeProblem(
      id: 283,
      title: 'Move Zeroes',
      difficulty: 'Easy',
      description: '''Given an integer array nums, move all 0's to the end of it while maintaining the relative order of the non-zero elements.

Note that you must do this in-place without making a copy of the array.''',
      examples: [
        '''Input: nums = [0,1,0,3,12]
Output: [1,3,12,0,0]''',
        '''Input: nums = [0]
Output: [0]''',
      ],
      testCases: [
        'nums = [0,1,0,3,12] → [1,3,12,0,0]',
        'nums = [0] → [0]',
        'nums = [1,2,3] → [1,2,3]',
      ],
      constraints: '''• 1 <= nums.length <= 10^4
• -2^31 <= nums[i] <= 2^31 - 1''',
      solution: '''#include <stdio.h>

void moveZeroes(int* nums, int numsSize) {
    int nonZeroPos = 0;
    
    // Move all non-zero elements to front
    for (int i = 0; i < numsSize; i++) {
        if (nums[i] != 0) {
            nums[nonZeroPos] = nums[i];
            nonZeroPos++;
        }
    }
    
    // Fill remaining with zeros
    for (int i = nonZeroPos; i < numsSize; i++) {
        nums[i] = 0;
    }
}

void printArray(int* nums, int size) {
    for (int i = 0; i < size; i++) {
        printf("%d ", nums[i]);
    }
    printf("\\n");
}

int main() {
    int nums1[] = {0,1,0,3,12};
    moveZeroes(nums1, 5);
    printArray(nums1, 5);  // 1 3 12 0 0
    
    return 0;
}''',
      explanation: '''**Approach: Two Pointers**

1. Use pointer to track position for non-zero elements
2. Copy all non-zero elements to front
3. Fill remaining positions with zeros

**Alternative:** Swap non-zero with zero in one pass

**Time Complexity:** O(n)
**Space Complexity:** O(1)''',
      topics: ['Array', 'Two Pointers'],
    ),

    // Problem 16: Contains Duplicate
    LeetCodeProblem(
      id: 217,
      title: 'Contains Duplicate',
      difficulty: 'Easy',
      description: '''Given an integer array nums, return true if any value appears at least twice in the array, and return false if every element is distinct.''',
      examples: [
        '''Input: nums = [1,2,3,1]
Output: true''',
        '''Input: nums = [1,2,3,4]
Output: false''',
        '''Input: nums = [1,1,1,3,3,4,3,2,4,2]
Output: true''',
      ],
      testCases: [
        'nums = [1,2,3,1] → true',
        'nums = [1,2,3,4] → false',
        'nums = [1,1,1,3,3,4,3,2,4,2] → true',
      ],
      constraints: '''• 1 <= nums.length <= 10^5
• -10^9 <= nums[i] <= 10^9''',
      solution: '''#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

// Comparison function for qsort
int compare(const void* a, const void* b) {
    return (*(int*)a - *(int*)b);
}

bool containsDuplicate(int* nums, int numsSize) {
    // Sort the array
    qsort(nums, numsSize, sizeof(int), compare);
    
    // Check adjacent elements
    for (int i = 1; i < numsSize; i++) {
        if (nums[i] == nums[i-1]) {
            return true;
        }
    }
    
    return false;
}

int main() {
    int nums1[] = {1,2,3,1};
    printf("%s\\n", containsDuplicate(nums1, 4) ? "true" : "false");  // true
    
    int nums2[] = {1,2,3,4};
    printf("%s\\n", containsDuplicate(nums2, 4) ? "true" : "false");  // false
    
    return 0;
}''',
      explanation: '''**Approach: Sorting**

1. Sort the array
2. Check if any adjacent elements are equal
3. If yes, duplicate exists

**Alternative:** Use hash set (not shown in C for simplicity)

**Time Complexity:** O(n log n) for sorting
**Space Complexity:** O(1) if sorting in-place''',
      topics: ['Array', 'Hash Table', 'Sorting'],
    ),

    // Problem 17: Missing Number
    LeetCodeProblem(
      id: 268,
      title: 'Missing Number',
      difficulty: 'Easy',
      description: '''Given an array nums containing n distinct numbers in the range [0, n], return the only number in the range that is missing from the array.''',
      examples: [
        '''Input: nums = [3,0,1]
Output: 2
Explanation: n = 3 since there are 3 numbers, so all numbers are in the range [0,3]. 2 is the missing number.''',
        '''Input: nums = [0,1]
Output: 2''',
        '''Input: nums = [9,6,4,2,3,5,7,0,1]
Output: 8''',
      ],
      testCases: [
        'nums = [3,0,1] → 2',
        'nums = [0,1] → 2',
        'nums = [9,6,4,2,3,5,7,0,1] → 8',
      ],
      constraints: '''• n == nums.length
• 1 <= n <= 10^4
• 0 <= nums[i] <= n
• All numbers are unique''',
      solution: '''#include <stdio.h>

int missingNumber(int* nums, int numsSize) {
    int n = numsSize;
    
    // Sum of first n natural numbers
    int expectedSum = n * (n + 1) / 2;
    
    // Sum of array elements
    int actualSum = 0;
    for (int i = 0; i < numsSize; i++) {
        actualSum += nums[i];
    }
    
    // Missing number is the difference
    return expectedSum - actualSum;
}

int main() {
    int nums1[] = {3,0,1};
    printf("%d\\n", missingNumber(nums1, 3));  // 2
    
    int nums2[] = {9,6,4,2,3,5,7,0,1};
    printf("%d\\n", missingNumber(nums2, 9));  // 8
    
    return 0;
}''',
      explanation: '''**Approach: Math (Sum Formula)**

1. Calculate expected sum: n*(n+1)/2
2. Calculate actual sum of array
3. Difference is the missing number

**Alternative:** XOR all numbers and indices

**Time Complexity:** O(n)
**Space Complexity:** O(1)''',
      topics: ['Array', 'Hash Table', 'Math', 'Bit Manipulation', 'Sorting'],
    ),

    // Problem 18: Intersection of Two Arrays
    LeetCodeProblem(
      id: 349,
      title: 'Intersection of Two Arrays',
      difficulty: 'Easy',
      description: '''Given two integer arrays nums1 and nums2, return an array of their intersection. Each element in the result must be unique and you may return the result in any order.''',
      examples: [
        '''Input: nums1 = [1,2,2,1], nums2 = [2,2]
Output: [2]''',
        '''Input: nums1 = [4,9,5], nums2 = [9,4,9,8,4]
Output: [9,4] or [4,9]''',
      ],
      testCases: [
        'nums1 = [1,2,2,1], nums2 = [2,2] → [2]',
        'nums1 = [4,9,5], nums2 = [9,4,9,8,4] → [4,9]',
      ],
      constraints: '''• 1 <= nums1.length, nums2.length <= 1000
• 0 <= nums1[i], nums2[i] <= 1000''',
      solution: '''#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

int* intersection(int* nums1, int nums1Size, int* nums2, int nums2Size, int* returnSize) {
    int* result = (int*)malloc(1000 * sizeof(int));
    *returnSize = 0;
    
    // Use array as hash set (since values are 0-1000)
    bool seen[1001] = {false};
    bool added[1001] = {false};
    
    // Mark all elements in nums1
    for (int i = 0; i < nums1Size; i++) {
        seen[nums1[i]] = true;
    }
    
    // Check nums2 and add to result if in nums1
    for (int i = 0; i < nums2Size; i++) {
        if (seen[nums2[i]] && !added[nums2[i]]) {
            result[*returnSize] = nums2[i];
            (*returnSize)++;
            added[nums2[i]] = true;
        }
    }
    
    return result;
}

int main() {
    int nums1[] = {1,2,2,1};
    int nums2[] = {2,2};
    int returnSize;
    
    int* result = intersection(nums1, 4, nums2, 2, &returnSize);
    
    for (int i = 0; i < returnSize; i++) {
        printf("%d ", result[i]);
    }
    printf("\\n");
    
    free(result);
    return 0;
}''',
      explanation: '''**Approach: Hash Set**

1. Use array as hash set for nums1
2. Iterate nums2 and check if in set
3. Add to result if found and not already added

**Alternative:** Sort both arrays and use two pointers

**Time Complexity:** O(n + m)
**Space Complexity:** O(n)''',
      topics: ['Array', 'Hash Table', 'Two Pointers', 'Binary Search', 'Sorting'],
    ),

    // Problem 19: Reverse String
    LeetCodeProblem(
      id: 344,
      title: 'Reverse String',
      difficulty: 'Easy',
      description: '''Write a function that reverses a string. The input string is given as an array of characters s.

You must do this by modifying the input array in-place with O(1) extra memory.''',
      examples: [
        '''Input: s = ["h","e","l","l","o"]
Output: ["o","l","l","e","h"]''',
        '''Input: s = ["H","a","n","n","a","h"]
Output: ["h","a","n","n","a","H"]''',
      ],
      testCases: [
        's = ["h","e","l","l","o"] → ["o","l","l","e","h"]',
        's = ["H","a","n","n","a","h"] → ["h","a","n","n","a","H"]',
      ],
      constraints: '''• 1 <= s.length <= 10^5
• s[i] is a printable ascii character''',
      solution: '''#include <stdio.h>

void reverseString(char* s, int sSize) {
    int left = 0;
    int right = sSize - 1;
    
    while (left < right) {
        // Swap characters
        char temp = s[left];
        s[left] = s[right];
        s[right] = temp;
        
        left++;
        right--;
    }
}

int main() {
    char s1[] = {'h','e','l','l','o'};
    reverseString(s1, 5);
    
    for (int i = 0; i < 5; i++) {
        printf("%c", s1[i]);
    }
    printf("\\n");  // olleh
    
    return 0;
}''',
      explanation: '''**Approach: Two Pointers**

1. Use left and right pointers
2. Swap characters at both ends
3. Move pointers towards center
4. Stop when they meet

**Classic two-pointer technique**

**Time Complexity:** O(n)
**Space Complexity:** O(1)''',
      topics: ['Two Pointers', 'String', 'Recursion'],
    ),

    // Problem 20: Fizz Buzz
    LeetCodeProblem(
      id: 412,
      title: 'Fizz Buzz',
      difficulty: 'Easy',
      description: '''Given an integer n, return a string array answer (1-indexed) where:

• answer[i] == "FizzBuzz" if i is divisible by 3 and 5.
• answer[i] == "Fizz" if i is divisible by 3.
• answer[i] == "Buzz" if i is divisible by 5.
• answer[i] == i (as a string) if none of the above conditions are true.''',
      examples: [
        '''Input: n = 3
Output: ["1","2","Fizz"]''',
        '''Input: n = 5
Output: ["1","2","Fizz","4","Buzz"]''',
        '''Input: n = 15
Output: ["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz"]''',
      ],
      testCases: [
        'n = 3 → ["1","2","Fizz"]',
        'n = 5 → ["1","2","Fizz","4","Buzz"]',
        'n = 15 → ["1","2","Fizz",...,"FizzBuzz"]',
      ],
      constraints: '''• 1 <= n <= 10^4''',
      solution: '''#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char** fizzBuzz(int n, int* returnSize) {
    *returnSize = n;
    char** result = (char**)malloc(n * sizeof(char*));
    
    for (int i = 1; i <= n; i++) {
        result[i-1] = (char*)malloc(20 * sizeof(char));
        
        if (i % 15 == 0) {
            strcpy(result[i-1], "FizzBuzz");
        } else if (i % 3 == 0) {
            strcpy(result[i-1], "Fizz");
        } else if (i % 5 == 0) {
            strcpy(result[i-1], "Buzz");
        } else {
            sprintf(result[i-1], "%d", i);
        }
    }
    
    return result;
}

int main() {
    int returnSize;
    char** result = fizzBuzz(15, &returnSize);
    
    for (int i = 0; i < returnSize; i++) {
        printf("%s ", result[i]);
        free(result[i]);
    }
    printf("\\n");
    
    free(result);
    return 0;
}''',
      explanation: '''**Approach: Conditional Checks**

1. Check divisibility by 15 first (both 3 and 5)
2. Then check divisibility by 3
3. Then check divisibility by 5
4. Otherwise, convert number to string

**Key:** Check 15 before 3 and 5

**Time Complexity:** O(n)
**Space Complexity:** O(1) excluding output''',
      topics: ['Math', 'String', 'Simulation'],
    ),

    // Problem 21: Valid Anagram
    LeetCodeProblem(
      id: 242,
      title: 'Valid Anagram',
      difficulty: 'Easy',
      description: '''Given two strings s and t, return true if t is an anagram of s, and false otherwise.

An Anagram is a word or phrase formed by rearranging the letters of a different word or phrase, typically using all the original letters exactly once.''',
      examples: [
        '''Input: s = "anagram", t = "nagaram"
Output: true''',
        '''Input: s = "rat", t = "car"
Output: false''',
      ],
      testCases: [
        's = "anagram", t = "nagaram" → true',
        's = "rat", t = "car" → false',
        's = "listen", t = "silent" → true',
      ],
      constraints: '''• 1 <= s.length, t.length <= 5 * 10^4
• s and t consist of lowercase English letters''',
      solution: '''#include <stdio.h>
#include <stdbool.h>
#include <string.h>

bool isAnagram(char* s, char* t) {
    if (strlen(s) != strlen(t)) return false;
    
    int count[26] = {0};
    
    // Count characters in s and decrement for t
    for (int i = 0; s[i] != '\\0'; i++) {
        count[s[i] - 'a']++;
        count[t[i] - 'a']--;
    }
    
    // Check if all counts are zero
    for (int i = 0; i < 26; i++) {
        if (count[i] != 0) return false;
    }
    
    return true;
}

int main() {
    printf("%s\\n", isAnagram("anagram", "nagaram") ? "true" : "false");  // true
    printf("%s\\n", isAnagram("rat", "car") ? "true" : "false");          // false
    return 0;
}''',
      explanation: '''**Approach: Character Counting**

1. Check if lengths are equal
2. Count frequency of each character
3. Increment for s, decrement for t
4. All counts should be zero if anagram

**Time Complexity:** O(n)
**Space Complexity:** O(1) - fixed size array''',
      topics: ['Hash Table', 'String', 'Sorting'],
    ),

    // Problem 22: First Bad Version
    LeetCodeProblem(
      id: 278,
      title: 'First Bad Version',
      difficulty: 'Easy',
      description: '''You are a product manager and currently leading a team to develop a new product. Unfortunately, the latest version of your product fails the quality check. Since each version is developed based on the previous version, all the versions after a bad version are also bad.

Suppose you have n versions [1, 2, ..., n] and you want to find out the first bad one, which causes all the following ones to be bad.

You are given an API bool isBadVersion(version) which returns whether version is bad.''',
      examples: [
        '''Input: n = 5, bad = 4
Output: 4
Explanation: call isBadVersion(3) -> false, call isBadVersion(5) -> true, call isBadVersion(4) -> true''',
        '''Input: n = 1, bad = 1
Output: 1''',
      ],
      testCases: [
        'n = 5, bad = 4 → 4',
        'n = 1, bad = 1 → 1',
        'n = 10, bad = 7 → 7',
      ],
      constraints: '''• 1 <= bad <= n <= 2^31 - 1''',
      solution: '''#include <stdio.h>
#include <stdbool.h>

// Mock API function (in real problem, this is provided)
bool isBadVersion(int version) {
    // Example: versions 4 and above are bad
    return version >= 4;
}

int firstBadVersion(int n) {
    int left = 1;
    int right = n;
    
    while (left < right) {
        int mid = left + (right - left) / 2;
        
        if (isBadVersion(mid)) {
            right = mid;  // First bad could be mid or earlier
        } else {
            left = mid + 1;  // First bad is after mid
        }
    }
    
    return left;
}

int main() {
    printf("%d\\n", firstBadVersion(5));   // 4
    printf("%d\\n", firstBadVersion(10));  // 4
    return 0;
}''',
      explanation: '''**Approach: Binary Search**

1. Use binary search to find first bad version
2. If mid is bad, search left half (including mid)
3. If mid is good, search right half (excluding mid)
4. Continue until left == right

**Time Complexity:** O(log n)
**Space Complexity:** O(1)''',
      topics: ['Binary Search', 'Interactive'],
    ),

    // Problem 23: Ransom Note
    LeetCodeProblem(
      id: 383,
      title: 'Ransom Note',
      difficulty: 'Easy',
      description: '''Given two strings ransomNote and magazine, return true if ransomNote can be constructed by using the letters from magazine and false otherwise.

Each letter in magazine can only be used once in ransomNote.''',
      examples: [
        '''Input: ransomNote = "a", magazine = "b"
Output: false''',
        '''Input: ransomNote = "aa", magazine = "ab"
Output: false''',
        '''Input: ransomNote = "aa", magazine = "aab"
Output: true''',
      ],
      testCases: [
        'ransomNote = "a", magazine = "b" → false',
        'ransomNote = "aa", magazine = "ab" → false',
        'ransomNote = "aa", magazine = "aab" → true',
      ],
      constraints: '''• 1 <= ransomNote.length, magazine.length <= 10^5
• ransomNote and magazine consist of lowercase English letters''',
      solution: '''#include <stdio.h>
#include <stdbool.h>
#include <string.h>

bool canConstruct(char* ransomNote, char* magazine) {
    int count[26] = {0};
    
    // Count characters in magazine
    for (int i = 0; magazine[i] != '\\0'; i++) {
        count[magazine[i] - 'a']++;
    }
    
    // Check if ransom note can be constructed
    for (int i = 0; ransomNote[i] != '\\0'; i++) {
        if (--count[ransomNote[i] - 'a'] < 0) {
            return false;
        }
    }
    
    return true;
}

int main() {
    printf("%s\\n", canConstruct("a", "b") ? "true" : "false");      // false
    printf("%s\\n", canConstruct("aa", "ab") ? "true" : "false");    // false
    printf("%s\\n", canConstruct("aa", "aab") ? "true" : "false");   // true
    return 0;
}''',
      explanation: '''**Approach: Character Counting**

1. Count frequency of each character in magazine
2. For each character in ransom note, decrement count
3. If count goes negative, not enough characters available
4. Return true if all characters can be used

**Time Complexity:** O(n + m)
**Space Complexity:** O(1) - fixed size array''',
      topics: ['Hash Table', 'String', 'Counting'],
    ),

    // Problem 24: Power of Two
    LeetCodeProblem(
      id: 231,
      title: 'Power of Two',
      difficulty: 'Easy',
      description: '''Given an integer n, return true if it is a power of two. Otherwise, return false.

An integer n is a power of two, if there exists an integer x such that n == 2^x.''',
      examples: [
        '''Input: n = 1
Output: true
Explanation: 2^0 = 1''',
        '''Input: n = 16
Output: true
Explanation: 2^4 = 16''',
        '''Input: n = 3
Output: false''',
      ],
      testCases: [
        'n = 1 → true',
        'n = 16 → true',
        'n = 3 → false',
        'n = 0 → false',
      ],
      constraints: '''• -2^31 <= n <= 2^31 - 1''',
      solution: '''#include <stdio.h>
#include <stdbool.h>

bool isPowerOfTwo(int n) {
    // Power of 2 must be positive and have only one bit set
    return n > 0 && (n & (n - 1)) == 0;
}

int main() {
    printf("%s\\n", isPowerOfTwo(1) ? "true" : "false");   // true
    printf("%s\\n", isPowerOfTwo(16) ? "true" : "false");  // true
    printf("%s\\n", isPowerOfTwo(3) ? "true" : "false");   // false
    printf("%s\\n", isPowerOfTwo(0) ? "true" : "false");   // false
    return 0;
}''',
      explanation: '''**Approach: Bit Manipulation**

1. Power of 2 has exactly one bit set
2. n & (n-1) removes the rightmost set bit
3. If result is 0, n had only one bit set
4. Also check n > 0 for positive numbers

**Bit trick:** Powers of 2: 1, 2, 4, 8, 16...
Binary: 1, 10, 100, 1000, 10000...

**Time Complexity:** O(1)
**Space Complexity:** O(1)''',
      topics: ['Math', 'Bit Manipulation', 'Recursion'],
    ),

    // Problem 25: Add Binary
    LeetCodeProblem(
      id: 67,
      title: 'Add Binary',
      difficulty: 'Easy',
      description: '''Given two binary strings a and b, return their sum as a binary string.''',
      examples: [
        '''Input: a = "11", b = "1"
Output: "100"''',
        '''Input: a = "1010", b = "1011"
Output: "10101"''',
      ],
      testCases: [
        'a = "11", b = "1" → "100"',
        'a = "1010", b = "1011" → "10101"',
        'a = "0", b = "0" → "0"',
      ],
      constraints: '''• 1 <= a.length, b.length <= 10^4
• a and b consist only of '0' or '1' characters
• Each string does not contain leading zeros except for the zero itself''',
      solution: '''#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* addBinary(char* a, char* b) {
    int lenA = strlen(a);
    int lenB = strlen(b);
    int maxLen = (lenA > lenB ? lenA : lenB) + 1;
    
    char* result = (char*)malloc((maxLen + 1) * sizeof(char));
    result[maxLen] = '\\0';
    
    int i = lenA - 1;
    int j = lenB - 1;
    int k = maxLen - 1;
    int carry = 0;
    
    while (i >= 0 || j >= 0 || carry) {
        int sum = carry;
        
        if (i >= 0) {
            sum += a[i] - '0';
            i--;
        }
        
        if (j >= 0) {
            sum += b[j] - '0';
            j--;
        }
        
        result[k] = (sum % 2) + '0';
        carry = sum / 2;
        k--;
    }
    
    // Remove leading zeros
    int start = 0;
    while (start < maxLen - 1 && result[start] == '0') {
        start++;
    }
    
    return result + start;
}

int main() {
    printf("%s\\n", addBinary("11", "1"));      // "100"
    printf("%s\\n", addBinary("1010", "1011")); // "10101"
    return 0;
}''',
      explanation: '''**Approach: Simulate Binary Addition**

1. Start from rightmost digits
2. Add corresponding digits plus carry
3. Result digit is sum % 2
4. New carry is sum / 2
5. Continue until all digits processed

**Time Complexity:** O(max(n, m))
**Space Complexity:** O(max(n, m))''',
      topics: ['Math', 'String', 'Bit Manipulation', 'Simulation'],
    ),

    // Problem 26: Diameter of Binary Tree
    LeetCodeProblem(
      id: 543,
      title: 'Diameter of Binary Tree',
      difficulty: 'Easy',
      description: '''Given the root of a binary tree, return the length of the diameter of the tree.

The diameter of a binary tree is the length of the longest path between any two nodes in a tree. This path may or may not pass through the root.

The length of a path between two nodes is represented by the number of edges between them.''',
      examples: [
        '''Input: root = [1,2,3,4,5]
Output: 3
Explanation: 3 is the length of the path [4,2,1,3] or [5,2,1,3].''',
        '''Input: root = [1,2]
Output: 1''',
      ],
      testCases: [
        'root = [1,2,3,4,5] → 3',
        'root = [1,2] → 1',
        'root = [1] → 0',
      ],
      constraints: '''• The number of nodes in the tree is in the range [1, 10^4]
• -100 <= Node.val <= 100''',
      solution: '''#include <stdio.h>
#include <stdlib.h>

struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
};

int maxDiameter = 0;

int depth(struct TreeNode* node) {
    if (node == NULL) return 0;
    
    int leftDepth = depth(node->left);
    int rightDepth = depth(node->right);
    
    // Update diameter if path through current node is longer
    int currentDiameter = leftDepth + rightDepth;
    if (currentDiameter > maxDiameter) {
        maxDiameter = currentDiameter;
    }
    
    // Return depth of current node
    return 1 + (leftDepth > rightDepth ? leftDepth : rightDepth);
}

int diameterOfBinaryTree(struct TreeNode* root) {
    maxDiameter = 0;
    depth(root);
    return maxDiameter;
}

int main() {
    // Example tree construction would go here
    printf("Diameter calculation for binary tree\\n");
    return 0;
}''',
      explanation: '''**Approach: Recursive Depth Calculation**

1. For each node, calculate depth of left and right subtrees
2. Diameter through current node = left depth + right depth
3. Update global maximum diameter
4. Return depth of current subtree

**Key Insight:** Diameter may not pass through root

**Time Complexity:** O(n)
**Space Complexity:** O(h) where h is height''',
      topics: ['Tree', 'Depth-First Search', 'Binary Tree'],
    ),

    // Problem 27: Middle of Linked List
    LeetCodeProblem(
      id: 876,
      title: 'Middle of the Linked List',
      difficulty: 'Easy',
      description: '''Given the head of a singly linked list, return the middle node of the linked list.

If there are two middle nodes, return the second middle node.''',
      examples: [
        '''Input: head = [1,2,3,4,5]
Output: [3,4,5]
Explanation: The middle node of the list is node 3.''',
        '''Input: head = [1,2,3,4,5,6]
Output: [4,5,6]
Explanation: Since the list has two middle nodes with values 3 and 4, we return the second one.''',
      ],
      testCases: [
        'head = [1,2,3,4,5] → [3,4,5]',
        'head = [1,2,3,4,5,6] → [4,5,6]',
        'head = [1] → [1]',
      ],
      constraints: '''• The number of nodes in the list is in the range [1, 100]
• 1 <= Node.val <= 100''',
      solution: '''#include <stdio.h>
#include <stdlib.h>

struct ListNode {
    int val;
    struct ListNode *next;
};

struct ListNode* middleNode(struct ListNode* head) {
    struct ListNode* slow = head;
    struct ListNode* fast = head;
    
    // Fast pointer moves 2 steps, slow moves 1 step
    while (fast != NULL && fast->next != NULL) {
        slow = slow->next;
        fast = fast->next->next;
    }
    
    return slow;
}

int main() {
    // Example usage - would need to create linked list
    printf("Finding middle of linked list\\n");
    return 0;
}''',
      explanation: '''**Approach: Two Pointers (Tortoise and Hare)**

1. Use slow and fast pointers
2. Fast moves 2 steps, slow moves 1 step
3. When fast reaches end, slow is at middle
4. For even length, returns second middle

**Classic technique for linked list problems**

**Time Complexity:** O(n)
**Space Complexity:** O(1)''',
      topics: ['Linked List', 'Two Pointers'],
    ),

    // Problem 28: Maximum Depth of Binary Tree
    LeetCodeProblem(
      id: 104,
      title: 'Maximum Depth of Binary Tree',
      difficulty: 'Easy',
      description: '''Given the root of a binary tree, return its maximum depth.

A binary tree's maximum depth is the number of nodes along the longest path from the root node down to the farthest leaf node.''',
      examples: [
        '''Input: root = [3,9,20,null,null,15,7]
Output: 3''',
        '''Input: root = [1,null,2]
Output: 2''',
      ],
      testCases: [
        'root = [3,9,20,null,null,15,7] → 3',
        'root = [1,null,2] → 2',
        'root = [] → 0',
      ],
      constraints: '''• The number of nodes in the tree is in the range [0, 10^4]
• -100 <= Node.val <= 100''',
      solution: '''#include <stdio.h>
#include <stdlib.h>

struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
};

int maxDepth(struct TreeNode* root) {
    if (root == NULL) return 0;
    
    int leftDepth = maxDepth(root->left);
    int rightDepth = maxDepth(root->right);
    
    return 1 + (leftDepth > rightDepth ? leftDepth : rightDepth);
}

int main() {
    // Example tree construction would go here
    printf("Maximum depth calculation\\n");
    return 0;
}''',
      explanation: '''**Approach: Recursive DFS**

1. Base case: null node has depth 0
2. Recursively find depth of left and right subtrees
3. Return 1 + maximum of left and right depths
4. Each recursive call adds 1 for current level

**Time Complexity:** O(n)
**Space Complexity:** O(h) where h is height''',
      topics: ['Tree', 'Depth-First Search', 'Binary Tree', 'Recursion'],
    ),

    // Problem 29: Convert Sorted Array to Binary Search Tree
    LeetCodeProblem(
      id: 108,
      title: 'Convert Sorted Array to Binary Search Tree',
      difficulty: 'Easy',
      description: '''Given an integer array nums where the elements are sorted in ascending order, convert it to a height-balanced binary search tree.

A height-balanced binary tree is a binary tree in which the depth of the two subtrees of every node never differs by more than one.''',
      examples: [
        '''Input: nums = [-10,-3,0,5,9]
Output: [0,-3,9,-10,null,5]
Explanation: [0,-10,5,null,-3,null,9] is also accepted.''',
        '''Input: nums = [1,3]
Output: [3,1] or [1,null,3]''',
      ],
      testCases: [
        'nums = [-10,-3,0,5,9] → balanced BST',
        'nums = [1,3] → balanced BST',
        'nums = [1] → [1]',
      ],
      constraints: '''• 1 <= nums.length <= 10^4
• -10^4 <= nums[i] <= 10^4
• nums is sorted in strictly ascending order''',
      solution: '''#include <stdio.h>
#include <stdlib.h>

struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
};

struct TreeNode* createNode(int val) {
    struct TreeNode* node = (struct TreeNode*)malloc(sizeof(struct TreeNode));
    node->val = val;
    node->left = NULL;
    node->right = NULL;
    return node;
}

struct TreeNode* sortedArrayToBSTHelper(int* nums, int left, int right) {
    if (left > right) return NULL;
    
    int mid = left + (right - left) / 2;
    struct TreeNode* root = createNode(nums[mid]);
    
    root->left = sortedArrayToBSTHelper(nums, left, mid - 1);
    root->right = sortedArrayToBSTHelper(nums, mid + 1, right);
    
    return root;
}

struct TreeNode* sortedArrayToBST(int* nums, int numsSize) {
    return sortedArrayToBSTHelper(nums, 0, numsSize - 1);
}

int main() {
    int nums[] = {-10, -3, 0, 5, 9};
    struct TreeNode* root = sortedArrayToBST(nums, 5);
    printf("BST created from sorted array\\n");
    return 0;
}''',
      explanation: '''**Approach: Divide and Conquer**

1. Choose middle element as root (ensures balance)
2. Recursively build left subtree from left half
3. Recursively build right subtree from right half
4. This maintains BST property and balance

**Time Complexity:** O(n)
**Space Complexity:** O(log n) for recursion stack''',
      topics: ['Array', 'Divide and Conquer', 'Tree', 'Binary Search Tree', 'Binary Tree'],
    ),

    // Problem 30: Path Sum
    LeetCodeProblem(
      id: 112,
      title: 'Path Sum',
      difficulty: 'Easy',
      description: '''Given the root of a binary tree and an integer targetSum, return true if the tree has a root-to-leaf path such that adding up all the values along the path equals targetSum.

A leaf is a node with no children.''',
      examples: [
        '''Input: root = [5,4,8,11,null,13,4,7,2,null,null,null,1], targetSum = 22
Output: true
Explanation: The root-to-leaf path with the target sum is shown.''',
        '''Input: root = [1,2,3], targetSum = 5
Output: false''',
        '''Input: root = [], targetSum = 0
Output: false''',
      ],
      testCases: [
        'root = [5,4,8,11,null,13,4,7,2,null,null,null,1], targetSum = 22 → true',
        'root = [1,2,3], targetSum = 5 → false',
        'root = [], targetSum = 0 → false',
      ],
      constraints: '''• The number of nodes in the tree is in the range [0, 5000]
• -1000 <= Node.val <= 1000
• -1000 <= targetSum <= 1000''',
      solution: '''#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
};

bool hasPathSum(struct TreeNode* root, int targetSum) {
    if (root == NULL) return false;
    
    // If leaf node, check if remaining sum equals node value
    if (root->left == NULL && root->right == NULL) {
        return targetSum == root->val;
    }
    
    // Recursively check left and right subtrees with reduced target
    int remainingSum = targetSum - root->val;
    return hasPathSum(root->left, remainingSum) || 
           hasPathSum(root->right, remainingSum);
}

int main() {
    // Example tree construction would go here
    printf("Path sum calculation\\n");
    return 0;
}''',
      explanation: '''**Approach: Recursive DFS**

1. Base case: null node returns false
2. If leaf node, check if target equals node value
3. Otherwise, recursively check left and right subtrees
4. Subtract current node value from target

**Time Complexity:** O(n)
**Space Complexity:** O(h) where h is height''',
      topics: ['Tree', 'Depth-First Search', 'Binary Tree'],
    ),

    // Problem 31: Symmetric Tree
    LeetCodeProblem(
      id: 101,
      title: 'Symmetric Tree',
      difficulty: 'Easy',
      description: '''Given the root of a binary tree, check whether it is a mirror of itself (i.e., symmetric around its center).''',
      examples: [
        '''Input: root = [1,2,2,3,4,4,3]
Output: true''',
        '''Input: root = [1,2,2,null,3,null,3]
Output: false''',
      ],
      testCases: [
        'root = [1,2,2,3,4,4,3] → true',
        'root = [1,2,2,null,3,null,3] → false',
        'root = [1] → true',
      ],
      constraints: '''• The number of nodes in the tree is in the range [1, 1000]
• -100 <= Node.val <= 100''',
      solution: '''#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
};

bool isMirror(struct TreeNode* left, struct TreeNode* right) {
    if (left == NULL && right == NULL) return true;
    if (left == NULL || right == NULL) return false;
    
    return (left->val == right->val) &&
           isMirror(left->left, right->right) &&
           isMirror(left->right, right->left);
}

bool isSymmetric(struct TreeNode* root) {
    if (root == NULL) return true;
    return isMirror(root->left, root->right);
}

int main() {
    printf("Symmetric tree check\\n");
    return 0;
}''',
      explanation: '''**Approach: Recursive Mirror Check**

1. Compare left subtree with right subtree
2. For symmetry: left->left should equal right->right
3. And left->right should equal right->left
4. Base cases: both null (symmetric), one null (not symmetric)

**Time Complexity:** O(n)
**Space Complexity:** O(h) where h is height''',
      topics: ['Tree', 'Depth-First Search', 'Breadth-First Search', 'Binary Tree'],
    ),

    // Problem 32: Invert Binary Tree
    LeetCodeProblem(
      id: 226,
      title: 'Invert Binary Tree',
      difficulty: 'Easy',
      description: '''Given the root of a binary tree, invert the tree, and return its root.''',
      examples: [
        '''Input: root = [4,2,7,1,3,6,9]
Output: [4,7,2,9,6,3,1]''',
        '''Input: root = [2,1,3]
Output: [2,3,1]''',
        '''Input: root = []
Output: []''',
      ],
      testCases: [
        'root = [4,2,7,1,3,6,9] → [4,7,2,9,6,3,1]',
        'root = [2,1,3] → [2,3,1]',
        'root = [] → []',
      ],
      constraints: '''• The number of nodes in the tree is in the range [0, 100]
• -100 <= Node.val <= 100''',
      solution: '''#include <stdio.h>
#include <stdlib.h>

struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
};

struct TreeNode* invertTree(struct TreeNode* root) {
    if (root == NULL) return NULL;
    
    // Swap left and right children
    struct TreeNode* temp = root->left;
    root->left = root->right;
    root->right = temp;
    
    // Recursively invert subtrees
    invertTree(root->left);
    invertTree(root->right);
    
    return root;
}

int main() {
    printf("Binary tree inversion\\n");
    return 0;
}''',
      explanation: '''**Approach: Recursive Swap**

1. Base case: null node returns null
2. Swap left and right children of current node
3. Recursively invert left and right subtrees
4. Return the root

**Famous problem that stumped a Google candidate!**

**Time Complexity:** O(n)
**Space Complexity:** O(h) where h is height''',
      topics: ['Tree', 'Depth-First Search', 'Breadth-First Search', 'Binary Tree'],
    ),

    // Problem 33: Same Tree
    LeetCodeProblem(
      id: 100,
      title: 'Same Tree',
      difficulty: 'Easy',
      description: '''Given the roots of two binary trees p and q, write a function to check if they are the same or not.

Two binary trees are considered the same if they are structurally identical, and the nodes have the same value.''',
      examples: [
        '''Input: p = [1,2,3], q = [1,2,3]
Output: true''',
        '''Input: p = [1,2], q = [1,null,2]
Output: false''',
        '''Input: p = [1,2,1], q = [1,1,2]
Output: false''',
      ],
      testCases: [
        'p = [1,2,3], q = [1,2,3] → true',
        'p = [1,2], q = [1,null,2] → false',
        'p = [1,2,1], q = [1,1,2] → false',
      ],
      constraints: '''• The number of nodes in both trees is in the range [0, 100]
• -10^4 <= Node.val <= 10^4''',
      solution: '''#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
};

bool isSameTree(struct TreeNode* p, struct TreeNode* q) {
    // Both null - same
    if (p == NULL && q == NULL) return true;
    
    // One null, one not - different
    if (p == NULL || q == NULL) return false;
    
    // Different values - different
    if (p->val != q->val) return false;
    
    // Recursively check left and right subtrees
    return isSameTree(p->left, q->left) && isSameTree(p->right, q->right);
}

int main() {
    printf("Same tree comparison\\n");
    return 0;
}''',
      explanation: '''**Approach: Recursive Comparison**

1. Base cases: both null (same), one null (different)
2. Compare current node values
3. Recursively compare left and right subtrees
4. All must be true for trees to be same

**Time Complexity:** O(min(m,n))
**Space Complexity:** O(min(m,n)) for recursion''',
      topics: ['Tree', 'Depth-First Search', 'Binary Tree'],
    ),

    // Problem 34: Subtree of Another Tree
    LeetCodeProblem(
      id: 572,
      title: 'Subtree of Another Tree',
      difficulty: 'Easy',
      description: '''Given the roots of two binary trees root and subRoot, return true if there is a subtree of root with the same structure and node values of subRoot and false otherwise.

A subtree of a binary tree tree is a tree that consists of a node in tree and all of this node's descendants.''',
      examples: [
        '''Input: root = [3,4,5,1,2], subRoot = [4,1,2]
Output: true''',
        '''Input: root = [3,4,5,1,2,null,null,null,null,0], subRoot = [4,1,2]
Output: false''',
      ],
      testCases: [
        'root = [3,4,5,1,2], subRoot = [4,1,2] → true',
        'root = [3,4,5,1,2,null,null,null,null,0], subRoot = [4,1,2] → false',
      ],
      constraints: '''• The number of nodes in the root tree is in the range [1, 2000]
• The number of nodes in the subRoot tree is in the range [1, 1000]
• -10^4 <= root.val <= 10^4
• -10^4 <= subRoot.val <= 10^4''',
      solution: '''#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
};

bool isSameTree(struct TreeNode* p, struct TreeNode* q) {
    if (p == NULL && q == NULL) return true;
    if (p == NULL || q == NULL) return false;
    if (p->val != q->val) return false;
    return isSameTree(p->left, q->left) && isSameTree(p->right, q->right);
}

bool isSubtree(struct TreeNode* root, struct TreeNode* subRoot) {
    if (root == NULL) return false;
    
    // Check if current node starts a matching subtree
    if (isSameTree(root, subRoot)) return true;
    
    // Recursively check left and right subtrees
    return isSubtree(root->left, subRoot) || isSubtree(root->right, subRoot);
}

int main() {
    printf("Subtree check\\n");
    return 0;
}''',
      explanation: '''**Approach: Recursive Search + Same Tree**

1. For each node in main tree, check if subtree starts there
2. Use isSameTree helper to compare trees
3. If not found at current node, check left and right subtrees
4. Return true if found anywhere

**Time Complexity:** O(m * n) worst case
**Space Complexity:** O(max(m,n)) for recursion''',
      topics: ['Tree', 'Depth-First Search', 'String Matching', 'Binary Tree', 'Hash Function'],
    ),

    // Problem 35: Lowest Common Ancestor of BST
    LeetCodeProblem(
      id: 235,
      title: 'Lowest Common Ancestor of a Binary Search Tree',
      difficulty: 'Medium',
      description: '''Given a binary search tree (BST), find the lowest common ancestor (LCA) node of two given nodes in the BST.

The lowest common ancestor is defined between two nodes p and q as the lowest node in T that has both p and q as descendants (where we allow a node to be a descendant of itself).''',
      examples: [
        '''Input: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 8
Output: 6
Explanation: The LCA of nodes 2 and 8 is 6.''',
        '''Input: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 4
Output: 2
Explanation: The LCA of nodes 2 and 4 is 2.''',
      ],
      testCases: [
        'root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 8 → 6',
        'root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 4 → 2',
      ],
      constraints: '''• The number of nodes in the tree is in the range [2, 10^5]
• -10^9 <= Node.val <= 10^9
• All Node.val are unique
• p != q
• p and q will exist in the BST''',
      solution: '''#include <stdio.h>
#include <stdlib.h>

struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
};

struct TreeNode* lowestCommonAncestor(struct TreeNode* root, struct TreeNode* p, struct TreeNode* q) {
    // Ensure p.val <= q.val for easier comparison
    if (p->val > q->val) {
        struct TreeNode* temp = p;
        p = q;
        q = temp;
    }
    
    while (root != NULL) {
        // If both nodes are in left subtree
        if (root->val > q->val) {
            root = root->left;
        }
        // If both nodes are in right subtree
        else if (root->val < p->val) {
            root = root->right;
        }
        // Current node is the LCA
        else {
            return root;
        }
    }
    
    return NULL;
}

int main() {
    printf("Lowest Common Ancestor in BST\\n");
    return 0;
}''',
      explanation: '''**Approach: BST Property**

1. Use BST property: left < root < right
2. If both nodes are smaller, go left
3. If both nodes are larger, go right
4. Otherwise, current node is LCA

**Key insight:** BST property makes this much simpler than general tree

**Time Complexity:** O(h) where h is height
**Space Complexity:** O(1) iterative solution''',
      topics: ['Tree', 'Depth-First Search', 'Binary Search Tree'],
    ),

    // Problem 36: Validate Binary Search Tree
    LeetCodeProblem(
      id: 98,
      title: 'Validate Binary Search Tree',
      difficulty: 'Medium',
      description: '''Given the root of a binary tree, determine if it is a valid binary search tree (BST).

A valid BST is defined as follows:
• The left subtree of a node contains only nodes with keys less than the node's key.
• The right subtree of a node contains only nodes with keys greater than the node's key.
• Both the left and right subtrees must also be binary search trees.''',
      examples: [
        '''Input: root = [2,1,3]
Output: true''',
        '''Input: root = [5,1,4,null,null,3,6]
Output: false
Explanation: The root node's value is 5 but its right child's value is 4.''',
      ],
      testCases: [
        'root = [2,1,3] → true',
        'root = [5,1,4,null,null,3,6] → false',
        'root = [1] → true',
      ],
      constraints: '''• The number of nodes in the tree is in the range [1, 10^4]
• -2^31 <= Node.val <= 2^31 - 1''',
      solution: '''#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <limits.h>

struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
};

bool validate(struct TreeNode* node, long min, long max) {
    if (node == NULL) return true;
    
    if (node->val <= min || node->val >= max) return false;
    
    return validate(node->left, min, node->val) &&
           validate(node->right, node->val, max);
}

bool isValidBST(struct TreeNode* root) {
    return validate(root, LONG_MIN, LONG_MAX);
}

int main() {
    printf("BST validation\\n");
    return 0;
}''',
      explanation: '''**Approach: Range Validation**

1. Each node must be within a valid range
2. Root can be any value (LONG_MIN to LONG_MAX)
3. Left child: (min, current_val)
4. Right child: (current_val, max)

**Common mistake:** Only comparing with immediate parent

**Time Complexity:** O(n)
**Space Complexity:** O(h) for recursion stack''',
      topics: ['Tree', 'Depth-First Search', 'Binary Search Tree'],
    ),

    // Problem 37: Kth Smallest Element in BST
    LeetCodeProblem(
      id: 230,
      title: 'Kth Smallest Element in a BST',
      difficulty: 'Medium',
      description: '''Given the root of a binary search tree, and an integer k, return the kth smallest value (1-indexed) of all the values of the nodes in the tree.''',
      examples: [
        '''Input: root = [3,1,4,null,2], k = 1
Output: 1''',
        '''Input: root = [5,3,6,2,4,null,null,1], k = 3
Output: 3''',
      ],
      testCases: [
        'root = [3,1,4,null,2], k = 1 → 1',
        'root = [5,3,6,2,4,null,null,1], k = 3 → 3',
      ],
      constraints: '''• The number of nodes in the tree is n
• 1 <= k <= n <= 10^4
• 0 <= Node.val <= 10^4''',
      solution: '''#include <stdio.h>
#include <stdlib.h>

struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
};

void inorder(struct TreeNode* root, int* count, int k, int* result) {
    if (root == NULL || *count >= k) return;
    
    inorder(root->left, count, k, result);
    
    (*count)++;
    if (*count == k) {
        *result = root->val;
        return;
    }
    
    inorder(root->right, count, k, result);
}

int kthSmallest(struct TreeNode* root, int k) {
    int count = 0;
    int result = 0;
    inorder(root, &count, k, &result);
    return result;
}

int main() {
    printf("Kth smallest element in BST\\n");
    return 0;
}''',
      explanation: '''**Approach: Inorder Traversal**

1. Inorder traversal of BST gives sorted order
2. Count nodes during traversal
3. Return value when count reaches k
4. Early termination when k is reached

**Time Complexity:** O(H + k) where H is height
**Space Complexity:** O(H) for recursion stack''',
      topics: ['Tree', 'Depth-First Search', 'Binary Search Tree'],
    ),

    // Problem 38: Binary Tree Level Order Traversal
    LeetCodeProblem(
      id: 102,
      title: 'Binary Tree Level Order Traversal',
      difficulty: 'Medium',
      description: '''Given the root of a binary tree, return the level order traversal of its nodes' values. (i.e., from left to right, level by level).''',
      examples: [
        '''Input: root = [3,9,20,null,null,15,7]
Output: [[3],[9,20],[15,7]]''',
        '''Input: root = [1]
Output: [[1]]''',
        '''Input: root = []
Output: []''',
      ],
      testCases: [
        'root = [3,9,20,null,null,15,7] → [[3],[9,20],[15,7]]',
        'root = [1] → [[1]]',
        'root = [] → []',
      ],
      constraints: '''• The number of nodes in the tree is in the range [0, 2000]
• -1000 <= Node.val <= 1000''',
      solution: '''#include <stdio.h>
#include <stdlib.h>

struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
};

// Queue implementation for BFS
struct QueueNode {
    struct TreeNode* treeNode;
    struct QueueNode* next;
};

struct Queue {
    struct QueueNode* front;
    struct QueueNode* rear;
    int size;
};

void enqueue(struct Queue* q, struct TreeNode* node) {
    struct QueueNode* newNode = (struct QueueNode*)malloc(sizeof(struct QueueNode));
    newNode->treeNode = node;
    newNode->next = NULL;
    
    if (q->rear == NULL) {
        q->front = q->rear = newNode;
    } else {
        q->rear->next = newNode;
        q->rear = newNode;
    }
    q->size++;
}

struct TreeNode* dequeue(struct Queue* q) {
    if (q->front == NULL) return NULL;
    
    struct QueueNode* temp = q->front;
    struct TreeNode* result = temp->treeNode;
    q->front = q->front->next;
    
    if (q->front == NULL) q->rear = NULL;
    
    free(temp);
    q->size--;
    return result;
}

int** levelOrder(struct TreeNode* root, int* returnSize, int** returnColumnSizes) {
    *returnSize = 0;
    if (root == NULL) return NULL;
    
    int** result = (int**)malloc(2000 * sizeof(int*));
    *returnColumnSizes = (int*)malloc(2000 * sizeof(int));
    
    struct Queue q = {NULL, NULL, 0};
    enqueue(&q, root);
    
    while (q.size > 0) {
        int levelSize = q.size;
        result[*returnSize] = (int*)malloc(levelSize * sizeof(int));
        (*returnColumnSizes)[*returnSize] = levelSize;
        
        for (int i = 0; i < levelSize; i++) {
            struct TreeNode* node = dequeue(&q);
            result[*returnSize][i] = node->val;
            
            if (node->left) enqueue(&q, node->left);
            if (node->right) enqueue(&q, node->right);
        }
        (*returnSize)++;
    }
    
    return result;
}

int main() {
    printf("Level order traversal\\n");
    return 0;
}''',
      explanation: '''**Approach: Breadth-First Search (BFS)**

1. Use queue to process nodes level by level
2. For each level, process all nodes currently in queue
3. Add children of current level to queue for next level
4. Store each level's values in separate array

**Time Complexity:** O(n)
**Space Complexity:** O(w) where w is maximum width''',
      topics: ['Tree', 'Breadth-First Search', 'Binary Tree'],
    ),

    // Problem 39: Construct Binary Tree from Preorder and Inorder
    LeetCodeProblem(
      id: 105,
      title: 'Construct Binary Tree from Preorder and Inorder Traversal',
      difficulty: 'Medium',
      description: '''Given two integer arrays preorder and inorder where preorder is the preorder traversal of a binary tree and inorder is the inorder traversal of the same tree, construct and return the binary tree.''',
      examples: [
        '''Input: preorder = [3,9,20,15,7], inorder = [9,3,15,20,7]
Output: [3,9,20,null,null,15,7]''',
        '''Input: preorder = [-1], inorder = [-1]
Output: [-1]''',
      ],
      testCases: [
        'preorder = [3,9,20,15,7], inorder = [9,3,15,20,7] → [3,9,20,null,null,15,7]',
        'preorder = [-1], inorder = [-1] → [-1]',
      ],
      constraints: '''• 1 <= preorder.length <= 3000
• inorder.length == preorder.length
• -3000 <= preorder[i], inorder[i] <= 3000
• preorder and inorder consist of unique values
• Each value of inorder also appears in preorder''',
      solution: '''#include <stdio.h>
#include <stdlib.h>

struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
};

struct TreeNode* createNode(int val) {
    struct TreeNode* node = (struct TreeNode*)malloc(sizeof(struct TreeNode));
    node->val = val;
    node->left = NULL;
    node->right = NULL;
    return node;
}

int findIndex(int* arr, int size, int val) {
    for (int i = 0; i < size; i++) {
        if (arr[i] == val) return i;
    }
    return -1;
}

struct TreeNode* buildTreeHelper(int* preorder, int* inorder, int inStart, int inEnd, int* preIndex) {
    if (inStart > inEnd) return NULL;
    
    // Root is the current element in preorder
    int rootVal = preorder[*preIndex];
    (*preIndex)++;
    
    struct TreeNode* root = createNode(rootVal);
    
    // Find root in inorder to split left and right subtrees
    int rootIndex = findIndex(inorder + inStart, inEnd - inStart + 1, rootVal) + inStart;
    
    // Build left subtree first (preorder: root, left, right)
    root->left = buildTreeHelper(preorder, inorder, inStart, rootIndex - 1, preIndex);
    root->right = buildTreeHelper(preorder, inorder, rootIndex + 1, inEnd, preIndex);
    
    return root;
}

struct TreeNode* buildTree(int* preorder, int preorderSize, int* inorder, int inorderSize) {
    int preIndex = 0;
    return buildTreeHelper(preorder, inorder, 0, inorderSize - 1, &preIndex);
}

int main() {
    printf("Build tree from traversals\\n");
    return 0;
}''',
      explanation: '''**Approach: Recursive Construction**

1. First element in preorder is always root
2. Find root in inorder to split left/right subtrees
3. Recursively build left subtree, then right subtree
4. Use preorder index to track current root

**Key insight:** Preorder gives roots, inorder gives boundaries

**Time Complexity:** O(n²) due to linear search
**Space Complexity:** O(n) for recursion stack''',
      topics: ['Array', 'Hash Table', 'Divide and Conquer', 'Tree', 'Binary Tree'],
    ),

    // Problem 40: Binary Tree Right Side View
    LeetCodeProblem(
      id: 199,
      title: 'Binary Tree Right Side View',
      difficulty: 'Medium',
      description: '''Given the root of a binary tree, imagine yourself standing on the right side of it, return the values of the nodes you can see ordered from top to bottom.''',
      examples: [
        '''Input: root = [1,2,3,null,5,null,4]
Output: [1,3,4]''',
        '''Input: root = [1,null,3]
Output: [1,3]''',
        '''Input: root = []
Output: []''',
      ],
      testCases: [
        'root = [1,2,3,null,5,null,4] → [1,3,4]',
        'root = [1,null,3] → [1,3]',
        'root = [] → []',
      ],
      constraints: '''• The number of nodes in the tree is in the range [0, 100]
• -100 <= Node.val <= 100''',
      solution: '''#include <stdio.h>
#include <stdlib.h>

struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
};

void rightSideViewHelper(struct TreeNode* root, int level, int* maxLevel, int* result, int* returnSize) {
    if (root == NULL) return;
    
    // If this is the first node at this level, add to result
    if (level > *maxLevel) {
        result[*returnSize] = root->val;
        (*returnSize)++;
        *maxLevel = level;
    }
    
    // Visit right first, then left
    rightSideViewHelper(root->right, level + 1, maxLevel, result, returnSize);
    rightSideViewHelper(root->left, level + 1, maxLevel, result, returnSize);
}

int* rightSideView(struct TreeNode* root, int* returnSize) {
    *returnSize = 0;
    if (root == NULL) return NULL;
    
    int* result = (int*)malloc(100 * sizeof(int));
    int maxLevel = -1;
    
    rightSideViewHelper(root, 0, &maxLevel, result, returnSize);
    
    return result;
}

int main() {
    printf("Right side view of binary tree\\n");
    return 0;
}''',
      explanation: '''**Approach: DFS with Level Tracking**

1. Traverse tree with level information
2. For each level, record first node encountered
3. Visit right subtree before left (rightmost first)
4. Only add to result if first time seeing this level

**Alternative:** BFS and take last node of each level

**Time Complexity:** O(n)
**Space Complexity:** O(h) where h is height''',
      topics: ['Tree', 'Depth-First Search', 'Breadth-First Search', 'Binary Tree'],
    ),
  ];

  // Helper methods for filtering and searching
  static List<LeetCodeProblem> getProblemsByDifficulty(String difficulty) {
    return allProblems.where((problem) => problem.difficulty == difficulty).toList();
  }

  static List<LeetCodeProblem> getProblemsByTopic(String topic) {
    return allProblems.where((problem) => problem.topics.contains(topic)).toList();
  }

  static List<String> getAllTopics() {
    Set<String> topics = {};
    for (var problem in allProblems) {
      topics.addAll(problem.topics);
    }
    return topics.toList()..sort();
  }

  static List<LeetCodeProblem> searchProblems(String query) {
    query = query.toLowerCase();
    return allProblems.where((problem) {
      return problem.title.toLowerCase().contains(query) ||
             problem.description.toLowerCase().contains(query) ||
             problem.topics.any((topic) => topic.toLowerCase().contains(query));
    }).toList();
  }

  static LeetCodeProblem? getProblemById(int id) {
    try {
      return allProblems.firstWhere((problem) => problem.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<LeetCodeProblem> getRandomProblems(int count) {
    List<LeetCodeProblem> shuffled = List.from(allProblems);
    shuffled.shuffle();
    return shuffled.take(count).toList();
  }
}

