require "date"
require "interpret_date/version"

module InterpretDate
  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods
    def interpret_date_assignment_for(*attributes)
      attributes.map(&:to_s).each do |field|
        define_method("#{field}=".to_sym) do |value|
          if defined?(super)
            super(interpret_date(value) || value)
          else
            instance_variable_set("@#{field}", interpret_date(value) || value)
          end
        end
      end
    end
  end

  def interpret_date(date_input, buffer = 10)
    # the number of years previous turn of the century + buffer number of years
    @century_divider = Date.today.year + buffer - current_century
    convert_date(date_input)
  end

  def interpret_dob_date(date_input)
    # the number of years since previous turn of the century
    @century_divider = Date.today.year - current_century
    convert_date(date_input)
  end

  private

  def current_century
    year = Date.today.year
    "#{year.to_s[0..1]}00".to_i
  end

  def contains_only_six_digits(value)
    /^\d{6}$/ =~ value
  end

  def contains_only_eight_digits(value)
    /^\d{8}$/ =~ value
  end

  def convert_date(date_input)
    # Only run the interpret_date code if we have a non-nil string,
    # otherwise, use #to_date to strip any time or timezone info
    return date_input.to_date unless date_input.is_a?(String) || date_input.nil?

    if contains_only_six_digits(date_input)
      # The date_input only contains digits, and must
      # be in the form MMDDYY
      month = date_input[0,2].to_i
      day   = date_input[2,2].to_i
      year  = date_input[4,2].to_i
    elsif contains_only_eight_digits(date_input)
      # The date_input only contains digits, and must
      # be in the form MMDDYYYY
      month = date_input[0,2].to_i
      day   = date_input[2,2].to_i
      year  = date_input[4,4].to_i
    elsif db_formatted_date(date_input)
      year, month, day = date_input.split("-").collect { |element| element.to_i }
    elsif slash_based_date(date_input)
      # Break the string apart using the delimiters '-', '/', and '.', making each element an integer
      month, day, year = date_input.split(/[-\.\/]+/).collect { |element| element.to_i }
    else
      return nil
    end

    # Do not allow a three-digit year
    return nil if year.to_s.size == 3

    # Modify two-digit years
    if year < 100
      # @century_divider represents the year where we
      # divide 2 digit years from the last century or the current one
      if year > @century_divider
        year += current_century - 100
      else
        year += current_century
      end
    end

    begin
      Date.new(year, month, day)
    rescue
      nil
    end
  end

  # -----------------------------------------
  # Does the input string match this pattern
  # and associated variations?
  #  * m/d/yy
  #  * mm/dd/yy
  #  * mm/dd/yyyy
  #  * m-d-yy
  #  * mm-dd-yy
  #  * mm-dd-yyyy
  # -----------------------------------------
  def slash_based_date(value)
    /^\d{1,2}([-\.\/]+)\d{1,2}\1\d{2,4}$/ =~ value
  end

  # Example: 2017-01-01
  def db_formatted_date(value)
    /^\d{4}-\d{2}-\d{2}$/ =~ value
  end
end
