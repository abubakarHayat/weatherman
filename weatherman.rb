# frozen_string_literal: true

require 'csv'
require 'pathname'
require './temperature_calcs'
require './arg_functions'
require './functions'
require 'rainbow'
class Weatherman
  include TemperatureCalcs
  include ArgFunctions
  include Functions
  attr_accessor :base_path

  def initialize
    @base_path = ''
    @month_map = {
      '1' => 'January',
      '2' => 'Feburary',
      '3' => 'March',
      '4' => 'April',
      '5' => 'May',
      '6' => 'June',
      '7' => 'July',
      '8' => 'August',
      '9' => 'September',
      '10' => 'October',
      '11' => 'November',
      '12' => 'December'
    }
  end

  def csv_parse(path)
    @lines = CSV.parse(File.read(path), headers: true, skip_blanks: true)
  end

  def make_path(path, year, month, arge: false)
    unless arge
      path_tokens = path.split('/')
      path = "#{path}/#{path_tokens[-1]}_#{year}_#{month[0, 3]}.txt"
    end

    @base_path = path if File.exist? path
    raise 'File not found!' unless File.exist? path
  rescue StandardError => e
    puts Rainbow('Error: ').red + e.message
  end

  def get_year_data(year)
    Dir.glob(@base_path + "/*#{year}*")
  end

  def print_min_max_range(max, min)
    print_times(min, max: false)
    print_times(max)
    print "#{Rainbow("#{min}C").blue} - #{Rainbow("#{max}C").red}\n"
  end

  def start
    raise "Incorrect number of arguments (#{ARGV.length}) provided, should be 3!" if ARGV.length != 3

    date = checker
    construct_path(date)
    return if @base_path == ''

    select_arg(date)
  rescue StandardError => e
    puts Rainbow('Error: ').red + e.message
  end
end
Weatherman.new.start
