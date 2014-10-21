require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  
  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end
end


User.new({'fname' => 'Iron', 'lname' => 'Man'}) 
User.new({'fname' => 'Joe', 'lname' => 'Brown'}).create
 
User.find_by_name("Joe", "Brown")


