class Reply
  attr_accessor :question_id, :parent_reply_id, :user_id, :body
  attr_reader :id
  
  def initialize(options = {})
    @id              = options['id']
    @question_id     = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @user_id         = options['user_id']
    @body            = options['body']
  end
  
  def self.find_by_id(id)
    reply_hash = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT *
      FROM 
      replies
      WHERE 
        id = ?
    SQL
    Reply.new(reply_hash.first)
  end
  
  def self.find_by_question_id(question_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT *
      FROM 
      replies
      WHERE 
        question_id = ?
    SQL
    replies.map { |hash| Reply.new(hash) }
  end
  
  def self.find_by_user_id(user_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT *
      FROM 
      replies
      WHERE 
        user_id = ?
    SQL
    replies.map { |hash| Reply.new(hash) }
  end
  
  
  def create
    QuestionsDatabase.instance.execute(<<-SQL, @question_id, @user_id, @body)
    INSERT INTO
      replies (question_id, user_id, body)
    VALUES
     (?, ?, ?)
    SQL
    
    @id = QuestionsDatabase.instance.last_insert_row_id
  end
  
  def author
    user_hash = QuestionsDatabase.instance.execute(<<-SQL, @user_id)
      SELECT *
      FROM 
        users 
      WHERE 
        id = ?
    SQL
    User.new(user_hash.first)
  end
  
  def question
    question_hash = QuestionsDatabase.instance.execute(<<-SQL, @question_id)
      SELECT *
      FROM 
        questions 
      WHERE 
        id = ?
    SQL
    Question.new(question_hash.first)
  end
  
  def parent_reply
    reply_hash = QuestionsDatabase.instance.execute(<<-SQL, @parent_reply_id)
      SELECT *
      FROM 
        replies 
      WHERE 
        id = ?
    SQL
    Reply.new(reply_hash.first)
  end
  
  def child_replies
    replies_hash = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT *
      FROM 
        replies 
      WHERE 
        parent_reply_id = ?
    SQL
     replies_hash.map {|hash| Reply.new(hash) }
  end
end
