class User
  attr_accessor :fname, :lname
  attr_reader   :id
  
  
  
  def initialize(options = {})
    @id       = options['id']
    @fname    = options['fname']
    @lname     = options['lname']
  end
  
  def asked_questions
    query = <<-SQL
    SELECT
    *
    FROM 
    questions
    WHERE
    user_id = ?
    SQL
    questions = QuestionsDatabase.instance.execute(query, @id)
    questions.map { |question_hash| Question.new(question_hash) }
  end
  
  
  
  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM users')
    results.map { |result| User.new(result) }
  end
  
  def self.find_by_id(id)
    user_hash = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT *
      FROM 
        users
      WHERE 
        id = ?
    SQL
    User.new(user_hash)
  end
  
  def self.find_by_name(fname, lname)
    
    user_hash = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT *
      FROM 
        users
      WHERE 
        fname = ?
        AND 
        lname = ?
    SQL
    p user_hash
    #User.new(user_hash)
  end
  
  def create
    raise "User already exists" unless self.id.nil?
    
    QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
    INSERT INTO
      users (fname, lname)
    VALUES
      (?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end
  
end


