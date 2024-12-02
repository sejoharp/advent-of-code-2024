defmodule Day1Test do
  use ExUnit.Case

  test "measures distance" do
    assert Day1.calculate_distance(3, 7) == 4
  end

  test "finds smallest number in list" do
    assert Day1.get_smallest_number_in_list([3, 4, 2, 1, 3, 3]) == 1
  end

  test "measures distance of both lists" do
    assert Day1.calculate_distance_of_lists([3, 4, 2, 1, 3, 3], [4, 3, 5, 3, 9, 3]) == 11
  end

  test "solves day one part one" do
    assert Day1.calculate_distance_of_lists(Day1.first_list, Day1.second_list) == 1_197_984
  end

  test "measures similarity score of both lists" do
    assert Day1.calculate_similarity_score_of_lists([3, 4, 2, 1, 3, 3], [4, 3, 5, 3, 9, 3]) == 31
  end

  test "solves day one part two" do
    assert Day1.calculate_similarity_score_of_lists3(Day1.first_list, Day1.second_list) == 23_387_399
  end
end
