defmodule Day2Test do
  use ExUnit.Case

  #  test "reads a file into a list of lists" do
  #    assert Day2.read_input() == 4
  #  end
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
    assert Day2.is_safe?([7, 6, 4, 2, 1]) == :safe
    assert Day2.is_safe?([1, 2, 7, 8, 9]) == :unsafe
    assert Day2.is_safe?([9, 7, 6, 2, 1]) == :unsafe
    assert Day2.is_safe?([1, 3, 2, 4, 5]) == :unsafe
    assert Day2.is_safe?([8, 6, 4, 4, 1]) == :unsafe
    assert Day2.is_safe?([1, 3, 6, 7, 9]) == :safe
  end

  test "remove new line and convert string to number" do
    assert Day2.convert_string_to_number("2") == 2
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
    test_input = Day2.read_input()
    assert Day2.count_safe_lists(test_input) == 306
  end
end
