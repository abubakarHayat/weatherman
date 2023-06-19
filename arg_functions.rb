module ArgFunctions
  def arg_c(year, month)
    out_chart = ''
    lines_arr = csv_parse(@base_path)
    raise '\"arg_c\", liness_arr is nill/empty!' if lines_arr.empty? && lines_arr.nil?

    ret_hash = min_max_td(lines_arr)
    puts "#{month} #{year}"

    ret_hash.each do |key, value|
      next if value[0].nil? || value[1].nil?

      out_chart = ''
      out_chart += "#{get_date(key, only_day: true)} "
      value[0].to_i.times { out_chart << '+' } unless value[0]&.nil?
      puts Rainbow(out_chart << ' ' << value[0] << 'C').red
      out_chart = "#{get_date(key, only_day: true)} "
      value[1].to_i.times { out_chart << '+' } unless value[1]&.nil?
      puts Rainbow(out_chart << ' ' << value[1] << 'C').blue
      print get_date(key, only_day: true).to_s
      print_min_max_range(value[0], value[1])
    end
  rescue StandardError => e
    puts Rainbow('Error: ').red + e.message
  end

  def arg_e(year)
    highest_temp = {}
    lowest_temp = {}
    highest_humidity = {}
    year_arr = get_year_data(year)
    raise 'Wrong year, File(s) not found!' if year_arr.empty?

    year_arr.each do |file_path|
      lines_arr = csv_parse(file_path)
      temp_arr = max_td(lines_arr)
      highest_temp[temp_arr[0]] = temp_arr[1]
      temp_arr = min_td(lines_arr)
      lowest_temp[temp_arr[0]] = temp_arr[1]
      temp_arr = max_td(lines_arr, 'Max Humidity')
      highest_humidity[temp_arr[0]] = temp_arr[1]
    end
    puts "Higest: #{highest_temp.values.max}C on #{get_date(highest_temp.key(highest_temp.values.max))}"
    puts "Lowest: #{lowest_temp.values.min}C on #{get_date(lowest_temp.key(lowest_temp.values.min))}"
    puts "Humidity: #{highest_humidity.values.max}% on #{get_date(highest_humidity.key(highest_humidity.values.max))}"
  rescue StandardError => e
    puts Rainbow('Error: ').red + e.message
  end

  def arg_a(_year, _month)
    lines_arr = csv_parse(@base_path)
    avg_highest_temp = avg_t(lines_arr, 'Max TemperatureC')
    avg_lowest_temp = avg_t(lines_arr, 'Min TemperatureC')
    avg_humidity = avg_t(lines_arr, ' Mean Humidity')
    puts "Higest: #{avg_highest_temp}C"
    puts "Lowest: #{avg_lowest_temp}C"
    puts "Humidity: #{avg_humidity}%"
  end

  def select_arg(date)
    case ARGV[0]
    when '-a'
      arg_a(date[0], @month_map[date[1]])
    when '-e'
      arg_e(date[0])
    when '-c'
      arg_c(date[0], @month_map[date[1]])
    else
      raise "No such flag as \"#{ARGV[0]}\""
    end
  rescue StandardError => e
    puts Rainbow('Error: ').red + e.message
  end
end
