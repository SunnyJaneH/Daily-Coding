# ============================================================
# ARRAY
# ============================================================

# [561] Array Partition (Easy)
# Given 2n integers, group into n pairs to maximize sum of min(a,b)
class Solution:
    def arrayPairSum(self, nums: List[int]) -> int:
        nums.sort()
        return sum(nums[0::2])

# [896] Monotonic Array (Easy)
# Return true if array is monotone increasing or decreasing
class Solution:
    def isMonotonic(self, nums: List[int]) -> bool:
        increasing = True
        decreasing = True
        for i in range(len(nums) - 1):
            diff = nums[i+1] - nums[i]
            if diff < 0:
                increasing = False
            elif diff > 0:
                decreasing = False
            if not increasing and not decreasing:
                return False
        return True

# [3379] Transformed Array (Easy)
# Circular array: move nums[i] steps right/left, store landing value
class Solution:
    def constructTransformedArray(self, nums: List[int]) -> List[int]:
        result = []
        for i, num in enumerate(nums):
            if nums[i] == 0:
                result.append(0)
            else:
                index = (i + nums[i]) % len(nums)
                result.append(nums[index])
        return result

# [88] Merge Sorted Array (Easy)
# Merge nums2 into nums1 in-place; nums1 has m+n slots, last n are 0s
# Key: slice assignment nums1[m:] = nums2 replaces placeholders directly
class Solution:
    def merge(self, nums1: List[int], m: int, n: int, nums2: List[int]) -> None:
        nums1[m:] = nums2
        nums1.sort()

# [941] Valid Mountain Array (Easy)
# Check if array strictly increases to a peak then strictly decreases
# Key: two pointers from both ends climbing to peak, must meet at same point
class Solution:
    def validMountainArray(self, arr: List[int]) -> bool:
        n = len(arr)
        left = 0
        right = n - 1

        while left + 1 < n and arr[left] < arr[left + 1]:
            left += 1

        while right - 1 >= 0 and arr[right] < arr[right - 1]:
            right -= 1

        return left == right and left != 0 and right != n - 1

# [1122] Relative Sort Array (Easy)
# Sort arr1 by arr2 order; elements not in arr2 go to end sorted ascending
# Key: iterate arr2, collect matching elements from arr1; append sorted remainder
class Solution:
    def relativeSortArray(self, arr1: List[int], arr2: List[int]) -> List[int]:
        result = []
        for num in arr2:
            for x in arr1:
                if x == num:
                    result.append(x)
        remaining = sorted([x for x in arr1 if x not in arr2])
        return result + remaining

# [1470] Shuffle the Array (Easy)
# Interleave first and second halves: [x1,x2,...,xn,y1,y2,...,yn] -> [x1,y1,x2,y2,...]
# Key: zip pairs elements from both halves; unpack each tuple with for x, y in zip()
class Solution:
    def shuffle(self, nums: List[int], n: int) -> List[int]:
        result = []
        for x, y in zip(nums[:n], nums[n:]):
            result.append(x)
            result.append(y)
        return result

# [1720] Decode XORed Array (Easy)
# Recover arr from encoded where encoded[i] = arr[i] XOR arr[i+1]
# Key: arr[i+1] = encoded[i] ^ arr[i]; XOR same number twice cancels out
class Solution:
    def decode(self, encoded: List[int], first: int) -> List[int]:
        arr = [first]
        for i in range(len(encoded)):
            arr.append(encoded[i] ^ arr[i])
        return arr
