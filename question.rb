class Question
  attr_accessor :title, :body, :user_id
  attr_reader :id
  
  def initialize(options = {})
    @id       = options['id']
    @title    = options['title']
    @body     = options['body']
    @user_id  = options['user_id']
  end
  
  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM questions')
    results.map { |result| Question.new(result) }
  end
  
  def self.find_by_id(id)
    question_hash = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT *
      FROM 
        questions
      WHERE 
        id = ?
    SQL
    Question.new(question_hash)
  end
  
  def create
    QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @user_id)
    INSERT INTO
      questions (title, body, user_id)
    VALUES
     (?, ?, ?)
    SQL
    
    @id = QuestionsDatabase.instance.last_insert_row_id
  end
  
  def author
    user = QuestionsDatabase.instance.execute(<<-SQL, @user_id)
    SELECT
    *
    FROM
    users
    WHERE
    id = ?
    SQL
    
    User.new(user.first)
  end
  
  def replies
    Reply.find_by_question_id(@id)
  end
  
  
  
end