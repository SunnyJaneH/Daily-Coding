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
