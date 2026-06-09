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
