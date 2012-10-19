module ConsoleCandy
  # Your code goes here...

  module ActiveRecord

    def self.included(base)
      base.send(:extend,ClassMethods)
      base.send(:include,InstanceMethods)
    end

    module ClassMethods

      def add_convenience_find_ids(*args)
        @convenience_ids = args
      end

      # A shortcut for find
      # Pass it either an id, a range, or a conditions string
      # Note that this returns nil if the items w/ indicated ID's are not there
      def [](*args)
        convenience_ids = [:id] + Array(@convenience_ids)
        if args.length > 1 
          # Assume it's a bunch of IDS
          if @convenience_ids.blank?
            find(args)
          else
            conditions = [convenience_ids.map { |att| "#{att} IN (?)"}.join(" OR ")] + [args]*convenience_ids.length
            find(:all,:conditions => conditions )
          end
        else
          arg = args.first
          if Range === arg
            # Note that this returns the objects based upon :offset, not the key, so User[0..3] returns the 
            # the first 4 objects in the User table, not the users with ids 0 through 3
            if arg.first > 0 
              self.all(:offset => arg.first, :limit => arg.to_a.length)
            else
              self.all(:offset => arg.last.abs-1, :limit => arg.to_a.length,:order => 'id DESC').reverse
            end
          else
            if String === arg && (arg.first == '%' || arg.last == '%')
              conditions = [convenience_ids.map { |att| %{#{att} LIKE ?} }.join(" OR ")] + [arg]*convenience_ids.length
            else
              conditions = [convenience_ids.map { |att| "#{att} = ?" }.join(" OR ")] + [arg]*convenience_ids.length
            end

            # We generally return only one, but if we have several matches, then return them all
            f = find(:all,:conditions => conditions)
            f.length == 1 ? f.first : f 
          end
        end
      end
    end


    module InstanceMethods
      # This method presents an easy way to display ActiveRecord objects in a readable format
      # for the console or embedding into an email 
      def pps
        order = [:special,:integer,:float,:boolean,:datetime,:date,:string,:text]
        sorted = {:special => []}
        %w(id type title name status kind).each { |s|
          sorted[:special] << s if attribute_names.include?(s)            
        }
        (attribute_names-sorted[:special]).inject(sorted) { |h,att_name|
          (h[column_for_attribute(att_name).type] ||= []) << att_name
          h
        }
        # find the max name length
        mnl = attribute_names.map { |n| n.length }.max + 1
        order.inject([]) { |arr,type|
          arr << (sorted[type] || []).map { |att_name| sprintf "%-#{mnl}s: %s", att_name, read_attribute(att_name).to_s.wrap(75-mnl).gsub("\n","\n#{' '*(mnl+2)}") }
          }.flatten.compact.join("\n")
      end

      def pp
        puts pps
      end

    end
  end
end
