defmodule Day1 do
  @moduledoc false

  def calculate_distance(a, b) do
    abs(a - b)
  end

  def get_smallest_number_in_list(location_id) do
    Enum.min(location_id)
  end

  def calculate_distance_of_lists(list1, list2) do
    calculate_distance_of_lists(list1, list2, 0)
  end

  def calculate_distance_of_lists([], [], aggregator) do
    aggregator
  end

  def calculate_distance_of_lists(list1, list2, aggregator) do
    min_number1 = get_smallest_number_in_list(list1)
    min_number2 = get_smallest_number_in_list(list2)
    new_list1 = List.delete(list1, min_number1)
    new_list2 = List.delete(list2, min_number2)
    distance = calculate_distance(min_number1, min_number2)
    calculate_distance_of_lists(new_list1, new_list2, aggregator + distance)
  end

  def calculate_similarity_score_of_lists(list1, list2) do
    calculate_similarity_score_of_lists(list1, list2, 0)
  end

  def calculate_similarity_score_of_lists([], _list2, aggregator) do
    aggregator
  end

  def calculate_similarity_score_of_lists([head | tail], list2, aggregator) do
    hits = Enum.filter(list2, fn x -> x == head end)
    calculate_similarity_score_of_lists(tail, list2, aggregator + head * length(hits))
  end

  def calculate_hit_count(list, number) do
    hits = Enum.filter(list, fn x -> x == number end)
    length(hits)
  end

  def calculate_similarity_score_of_lists2(list1, list2) do
    hit_counts =
      Enum.map(list1, fn number ->
        hits = calculate_hit_count(list2, number)
        hits * number
      end)

    Enum.sum(hit_counts)
  end

  def calculate_similarity_score_of_lists3(list1, list2) do
    {_, hit_counts} =
      Enum.map_reduce(list1, 0, fn number, acc ->
        hits = calculate_hit_count(list2, number)
        {0, acc + (hits * number)}
      end)

    hit_counts
  end
end
