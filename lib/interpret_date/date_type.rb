require "active_record"

module InterpretDate
  class DateType < ActiveRecord::Type::Date
    include InterpretDate

    def cast(value)
      super(interpret_date(value) || value)
    end
  end
end
