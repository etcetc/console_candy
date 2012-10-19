# ConsoleCandy

ConsoleCandy extends ActiveRecord to make it easier to inspect objects in the console.  Specifically, it does 3 things:
1) Adds the [] to models, so that User[223] returns the User with id 223
2) Adds a .show method to collections and arrays, so that you can write User.all.show(:id,:name) to create a tabular list in the console consisting of only the user's ID and names
3) Adds a pp method to objects to print the object in a somewhat nicer format
## Installation

Add this line to your application's Gemfile:

    gem 'console_candy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install console_candy

## Usage

Simply:

  require 'console_candy'
  
then you can use the indicated formalisms, examples:

  User[10]: finds user with id 10.
  User[10..12].show(:id,:name,:email) prints a table with id, name, and email for for users with offsets 10-12 in the DB (not IDs 10-12)
  User[-3..-1].show(:id,:name,:email) prints the same table for the last three users
  User[10].pp (or User[10].pps to return a string that you can them put in email for e.g.)
  
Also, in your class, you can add other ways to find an object, for example:

  class User
    add_convenience_find_ids :email
  
  end
  
  User['joe@yahoo.com'] will return the user with the indicated email
  User['%@yahoo.com'] will return all users whose emails end with yahoo.com
  User['%yahoo.%'] will return all users whose emails end in yahoo.com, yahoo.net, yahoo.edu or any other suffix
  
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
