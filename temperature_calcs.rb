module TemperatureCalcs
  def avg_t(arr_2d, col_name = 'Mean TemperatureC')
    sum = 0
    counter = 0
    arr_2d.each do |row|
      sum += row[col_name].to_i unless row[col_name].nil?
      counter += 1
    end
    (sum / counter)
  end

  def max_td(arr_2d, col_name = 'Max TemperatureC', give_date = true)
    max_arr_nil = []
    max_arr = []
    date = []
    arr_2d.each do |row|
      if !row[col_name].nil?
        max_arr << row[col_name].to_i
        max_arr_nil << row[col_name]
      else
        max_arr_nil << row[col_name]
      end
      date << row['GST']
    end
    max = max_arr.max
    if give_date
      [] << arr_2d[max_arr.find_index(max)]['GST'] << max
    else
      max
    end
  end

  def min_td(arr_2d, col_name = 'Min TemperatureC', give_date = true)
    min_arr_nil = []
    min_arr = []
    date = []
    arr_2d.each do |row|
      if !row[col_name].nil?
        min_arr << row[col_name].to_i
        min_arr_nil << row[col_name]
      else
        min_arr_nil << row[col_name]
      end
      date << row['GST']
    end
    min = min_arr.min
    if give_date
      [] << arr_2d[min_arr.find_index(min)]['GST'] << min
    else
      min
    end
  end

  def min_max_td(arr_2d)
    ret_hash = {}
    arr_2d.each do |row|
      temperature_arr = []
      temperature_arr << row['Max TemperatureC'] << row['Min TemperatureC']
      ret_hash[row['GST']] = temperature_arr
    end
    ret_hash
  end
end
