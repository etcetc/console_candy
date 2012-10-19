module ConsoleCandy

  module Collection
    # Return an array of the ids of the objects w/in
    def ids
      map { |x| x.id }
    end

    # This method is called to show certain attributes in a named scope
    # Usage: User.all.show(:id,:name,:email)
    def show(*args)
      r=map { |record| 
        args.map { |attr| 
          # If the attribute has a . in it, we split it and go down it recursively, so we can 
          # print items in associated models
          as = attr.to_s.split('.')
          r = record.send(as.shift.to_sym)
          as.each { |a| 
            r = r.send(a.to_sym)
          }
          if Array === r 
            r = r*','
          elsif Hash ===r
            r = r.inspect
          else
            r.to_s 
          end
        } 
      }
      # Find the max width for each column
      max = (0...args.length).map { |i| 
        column = r.map { |row| row[i] }
        column.map{ |s| s.length}.max 
      }
      format = max.map{ |l| "%#{l}s"}.join(" : ") + "\n" 
      r.each { |row|
        printf format,*row
      }
      nil
    end

  end

end
