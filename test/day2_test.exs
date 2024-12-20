defmodule Day2Test do
  use ExUnit.Case

 test "detects that first two is increasing" do
   assert Day2.detect_sorting([1, 2, 3, 4]) == :increase
 end

 test "detects that first two is not increasing" do
   assert Day2.detect_sorting([1, 0, 3, 4]) == :decrease
 end

 test "detects that first two is equal" do
   assert Day2.detect_sorting([1, 1, 3, 4]) == :equal
 end

 test "detects all increasing is safe" do
   assert Day2.detect_state([1, 2, 3, 4], :increase) == :safe
 end

 test "detects all decreasing is safe" do
   assert Day2.detect_state([4, 3, 2, 1], :decrease) == :safe
 end

 test "detects equal is unsafe" do
   assert Day2.detect_state([1, 1, 2, 3], :equal) == :unsafe
 end

 test "detects list is safe" do
   assert Day2.safe?([7, 6, 4, 2, 1]) == true
   assert Day2.safe?([1, 2, 7, 8, 9]) == false
   assert Day2.safe?([9, 7, 6, 2, 1]) == false
   assert Day2.safe?([1, 3, 2, 4, 5]) == false
   assert Day2.safe?([8, 6, 4, 4, 1]) == false
   assert Day2.safe?([1, 3, 6, 7, 9]) == true
 end

 test "counts safe lists" do
   test_input = [
     [7, 6, 4, 2, 1],
     [1, 2, 7, 8, 9],
     [9, 7, 6, 2, 1],
     [1, 3, 2, 4, 5],
     [8, 6, 4, 4, 1],
     [1, 3, 6, 7, 9]
   ]

   assert Day2.count_safe_lists(test_input) == 2
 end

 test "solves day two part 1" do
   test_input = Day2.read_input("lib/day2_input.txt")
   assert Day2.count_safe_lists(test_input) == 306
 end

  test "detects list is safe with one outlier" do
   assert Day2.problem_dampener([7, 6, 4, 2, 1]) == true
   assert Day2.problem_dampener([1, 2, 7, 8, 9]) == false
   assert Day2.problem_dampener([9, 7, 6, 2, 1]) == false
   assert Day2.problem_dampener([1, 3, 2, 4, 5]) == true

   assert Day2.problem_dampener([8, 6, 4, 4, 1]) == true
   assert Day2.problem_dampener([1, 3, 6, 7, 9]) == true

   assert Day2.problem_dampener([3, 3, 6, 7, 9]) == true
   assert Day2.problem_dampener([6, 6, 5, 3, 1]) == true

   assert Day2.problem_dampener([1, 0, 2, 4, 5]) == true

   assert Day2.problem_dampener([95, 95, 93, 87, 86]) == false
   assert Day2.problem_dampener([15, 15, 14, 13, 12, 6, 8]) == false
   assert Day2.problem_dampener([15, 16, 14, 15, 12, 13, 8]) == false

   assert Day2.problem_dampener([3, 3, 3, 6, 7]) == false
   assert Day2.problem_dampener([3, 3, 3, 2, 1]) == false
  end

 test "counts safe lists with outlier" do
   test_input = [
     [7, 6, 4, 2, 1],
     [1, 2, 7, 8, 9],
     [9, 7, 6, 2, 1],
     [1, 3, 2, 4, 5],
     [8, 6, 4, 4, 1],
     [1, 3, 6, 7, 9]
   ]

   assert Day2.count_safes(test_input) == 4
 end

 test "solves day two part 2" do
   test_input = Day2.read_input("lib/day2_input.txt")
   assert Day2.count_safes(test_input) == 366
 end
end
