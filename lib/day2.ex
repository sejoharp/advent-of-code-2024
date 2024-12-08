defmodule Day2 do
  @moduledoc false

  def read_input(input_path) do
    case File.open(input_path, [:read]) do
      {:ok, file} ->
        lines =
          IO.stream(file, :line)
          |> Enum.to_list()
          |> Enum.map(fn line ->
            line
            |> (fn line -> String.replace(line, "\n", "") end).()
            |> (fn line -> String.split(line, " ") end).()
            |> Enum.map(fn string_numbers -> String.to_integer(string_numbers) end)
          end)

        File.close(file)
        lines

      {:error, reason} ->
        IO.puts("Failed to open file: #{reason}")
    end
  end

  def detect_sorting([first, second | _numbers]) when first < second do
    :increase
  end

  def detect_sorting([first, second | _numbers]) when first > second do
    :decrease
  end

  def detect_sorting([first, second | _numbers]) when first == second do
    :equal
  end

  def detect_state([first | numbers], sorting) when sorting == :increase do
    second = List.first(numbers)

    valid_distance = first < second and abs(first - second) in 1..3

    cond do
      valid_distance and length(numbers) == 1 -> :safe
      valid_distance -> detect_state(numbers, :increase)
      true -> :unsafe
    end
  end

  def detect_state([first | numbers], sorting) when sorting == :decrease do
    second = List.first(numbers)

    valid_distance = first > second and abs(first - second) in 1..3

    cond do
      valid_distance and length(numbers) == 1 -> :safe
      valid_distance -> detect_state(numbers, :decrease)
      true -> :unsafe
    end
  end

  def detect_state(_numbers, sorting) when sorting == :equal do
    :unsafe
  end

  def safe?(numbers) do
    sorting = detect_sorting(numbers)
    detect_state(numbers, sorting) == :safe
  end

  def count_safe_lists(number_lists) do
    safe_lists =
      Enum.filter(number_lists, fn number_list -> safe?(number_list) end)

    length(safe_lists)
  end

  def valid_increase?(first, second) do
    second >= first + 1 and second <= first + 3
  end

  def valid_decrease?(first, second) do
    second <= first - 1 and second >= first - 3
  end

  def detect_state_with_one_outlier(_numbers, 2, _sorting) do
    :unsafe
  end

  def detect_state_with_one_outlier([_first], _outlier_count, _sorting) do
    :safe
  end

  def detect_state_with_one_outlier([_head | tail], outlier_count, :equal) do
    sorting = detect_sorting(tail)
    detect_state_with_one_outlier(tail, outlier_count + 1, sorting)
  end

  def detect_state_with_one_outlier([first, second | rest], outlier_count, :increase) do
    cond do
      valid_increase?(first, second) ->
        detect_state_with_one_outlier([second | rest], outlier_count, :increase)

      outlier_count == 0 ->
        detect_state_with_one_outlier([first | rest], 1, :increase)

      outlier_count == 1 ->
        :unsafe
    end
  end

  def detect_state_with_one_outlier([first, second | rest], outlier_count, :decrease) do
    cond do
      valid_decrease?(first, second) ->
        detect_state_with_one_outlier([second | rest], outlier_count, :decrease)

      outlier_count == 0 ->
        detect_state_with_one_outlier([first | rest], 1, :decrease)

      outlier_count == 1 ->
        :unsafe
    end
  end

  def detect_state_with_one_outlier([_first], outlier_count, _sorting) do
    cond do
      outlier_count <= 1 -> :safe
      outlier_count > 1 -> :unsafe
    end
  end

  def safe_with_outlier?(numbers) do
    sorting = detect_sorting(numbers)
    detect_state_with_one_outlier(numbers, 0, sorting)
  end

  def count_safe_with_outlier_lists(number_lists) do
    safe_lists =
      Enum.filter(number_lists, fn number_list ->
        safe_with_outlier?(number_list) == :safe
      end)

    length(safe_lists)
  end

  def safe_increase_level?(numbers) do
    safe_increase_level?(numbers, :ok)
  end

  def safe_increase_level?(numbers, state) do
    if length(numbers) == 1 do
      :safe
    else
      [first, second | tail] = numbers

      cond do
        valid_increase?(first, second) -> safe_increase_level?([second | tail], state)
        state == :outliner -> :unsafe
        true -> safe_increase_level?([first | tail], :outliner)
      end
    end
  end

  def safe_decrease_level?(numbers) do
    safe_decrease_level?(numbers, :ok)
  end

  def safe_decrease_level?(numbers, state) do
    if length(numbers) == 1 do
      :safe
    else
      [first, second | tail] = numbers

      cond do
        valid_decrease?(first, second) -> safe_decrease_level?([second | tail], state)
        state == :outliner -> :unsafe
        true -> safe_decrease_level?([first | tail], :outliner)
      end
    end
  end

  def forward_to_sorting_checker(numbers) do
    forward_to_sorting_checker(numbers, :ok)
  end

  def forward_to_sorting_checker(numbers, state) do
    if length(numbers) == 1 do
      :safe
    else
      [first, second | _tail] = numbers

      cond do
        first == second and state == :ok ->
          forward_to_sorting_checker(tl(numbers), :outlier)

        first == second and state == :outlier ->
          :unsafe

        first < second ->
          safe_increase_level?(numbers, state)

        first > second ->
          safe_decrease_level?(numbers, state)
      end
    end
  end

  def increase?([first | numbers]) do
    second = List.first(numbers)

    valid_distance = first < second and abs(first - second) in 1..3

    cond do
      valid_distance and length(numbers) == 1 -> true
      valid_distance -> increase?(numbers)
      true -> false
    end
  end

  def decrease?([first | numbers]) do
    second = List.first(numbers)

    valid_distance = first > second and abs(first - second) in 1..3

    cond do
      valid_distance and length(numbers) == 1 -> true
      valid_distance -> decrease?(numbers)
      true -> false
    end
  end

  def decreasing?([first, second | _numbers]) do
    first > second
  end

  def safe_freddy?(numbers) do
    if decreasing?(numbers) do
      decrease?(numbers)
    else
      increase?(numbers)
    end
  end

  def problem_dampener(report) do
    problem_dampener(report, report, 0)
  end

  def problem_dampener(original_report, report, index) do
    #     IO.inspect(original_report, label: "original report:       ")
    #     IO.inspect(List.pop_at(original_report, index), label:     "current report:    ")
    #     IO.inspect(List.delete_at(original_report, index), label: "deleted element report:")
    #     IO.inspect(index, label: "index")
    #     IO.inspect(length(report) == index + 1, label: "all tested")
    #     IO.inspect(safe?(report), label: "safe?")
    #     IO.puts("-------")
    cond do
      length(original_report) == index + 1 ->
        false

      safe_freddy?(report) ->
        true

      true ->
        problem_dampener(original_report, List.delete_at(original_report, index), index + 1)
    end
  end

  def count_safes(lines) do
    states = Enum.map(lines, fn line -> problem_dampener(line) end)
    safe_states = Enum.filter(states, fn state -> state == true end)
    length(safe_states)
  end
end
