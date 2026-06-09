# ============================================================
# HASH MAP / SET
# ============================================================

# [1] Two Sum (Easy)
# Find two indices that add up to target
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        seen = {}
        for i, num in enumerate(nums):
            complement = target - num
            if complement in seen:
                return [seen[complement], i]
            seen[num] = i


# [217] Contains Duplicate (Easy)
# Return true if any value appears at least twice
class Solution:
    def containsDuplicate(self, nums: List[int]) -> bool:
        seen = set()
        for num in nums:
            if num in seen:
                return True
            seen.add(num)
        return False
