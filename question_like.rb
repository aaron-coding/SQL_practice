class QuestionLike
  attr_accessor :question_id, :user_id
  attr_reader :id
  
  def initialize(options = {})
    @id              = options['id']
    @question_id     = options['question_id']
    @user_id         = options['user_id']
  end
  
  def self.find_by_id(id)
    question_like_hash = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT *
      FROM 
      question_likes
      WHERE 
        id = ?
    SQL
    Reply.new(question_like_hash)
  end
  
  def self.likers_for_question_id(question_id)
    users = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT users.id, fname, lname
    FROM 
      question_likes
    JOIN 
      users
    ON
      users.id = question_likes.user_id
    WHERE
      question_id = ?
    SQL
    users.map {|user| User.new(user) }
  end
  
  def self.liked_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      questions.id, title, body, questions.user_id
    FROM
    question_likes
    JOIN
    questions ON question_likes.question_id = questions.id
    WHERE
    question_likes.user_id = ?
    SQL
    questions.map { |hash| Question.new(hash) }
  end
  
  def self.num_likes_for_question_id(question_id)
    nums = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT COUNT(users.id) AS num
    FROM 
      question_likes
    JOIN 
      users
    ON
      users.id = question_likes.user_id
    WHERE
      question_id = ?
    SQL
    nums.first['num']
  end
  
  def create
    QuestionsDatabase.instance.execute(<<-SQL, @question_id, @user_id)
    INSERT INTO question_likes (question_id, user_id)
    VALUES
    ( ?, ? )
    SQL
    
    @id = QuestionsDatabase.instance.last_insert_row_id
  end
  
  def self.most_liked_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT questions.id, body, title, questions.user_id
      FROM 
       questions
      JOIN 
       question_likes
      ON 
        questions.id = question_id
      GROUP BY
        questions.id
      ORDER BY 
        COUNT(question_id) DESC
      LIMIT ?
    SQL
    questions.map {|hash| Question.new(hash) }
  end
  
end
