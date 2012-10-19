module ConsoleCandy
  require "console_candy/version"
  require "console_candy/active_record"
  require "console_candy/collection"

  ::ActiveRecord::Base.send(:include, ConsoleCandy::ActiveRecord)
  Array.send(:include,ConsoleCandy::Collection)

end