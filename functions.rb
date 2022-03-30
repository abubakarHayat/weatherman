# frozen_string_literal: true

module Functions
  def avg_temp_month(year, month)
    lines_arr = csv_parse("#{@base_path}_#{year}_#{month[0, 3]}.txt")
    avg_t(lines_arr)
  end

  def max_temp_month(year, month)
    lines_arr = csv_parse("#{@base_path}_#{year}_#{month[0, 3]}.txt")
    max_td(lines_arr)
  end

  def min_temp_month(year, month)
    lines_arr = csv_parse("#{@base_path}_#{year}_#{month[0, 3]}.txt")
    min_td(lines_arr)
  end

  def get_date(date, only_day: false)
    date = date.split('-')
    return date[2] if only_day

    "#{@month_map[date[1]][0, 3]} #{date[2]}"
  end

  def print_times(out, max: true)
    out_str = ''
    out.to_i.times do
      out_str << '+'
    end
    print Rainbow(out_str).red if max
    print Rainbow(out_str).blue unless max
  end

  def checker
    date = []
    raise 'Wrong options given for flag "-e"' if exception_condition

    if split_condition
      date = ARGV[1].split('/')
    else
      date << ARGV[1]
    end
    raise 'No such year/month exists!' if @month_map[date[1]].nil? && (ARGV[0] != '-e')

    date
  end

  def exception_condition
    !ARGV[1].nil? && (ARGV[1].include? '/') && ARGV[0] == '-e'
  end

  def split_condition
    !ARGV[1].nil? && (ARGV[1].include? '/')
  end

  def construct_path(date)
    if ARGV[0] == '-e'
      make_path(ARGV[-1], date[0], @month_map[date[1]], arge: true)
    else
      make_path(ARGV[-1], date[0], @month_map[date[1]])
    end
  end
end
