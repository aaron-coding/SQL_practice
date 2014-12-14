class QuestionFollower
  attr_accessor :question_id, :follower_id
  attr_reader :id
  
  def initialize(options = {})
    @id            = options['id']
    @question_id   = options['question_id']
    @follower_id   = options['follower_id']
  end
  
  def self.all
    results = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT 
        *
      FROM 
        question_followers
    SQL
    results.map { |result| QuestionFollower.new(result) }
  end
  
  def self.find_by_id(id)
    qf_hash = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT *
      FROM 
      question_followers
      WHERE 
        id = ?
    SQL
    QuestionFollower.new(qf_hash)
  end
  
  def self.followers_for_question_id(question_id)
    users = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT users.id, fname, lname
    FROM 
      question_followers
    JOIN 
      users
    ON
      users.id = question_followers.follower_id
    WHERE
      question_id = ?
    SQL
    
    users.map {|user| User.new(user) }
  end
  
  def self.followed_questions_for_user_id(u_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, u_id)
    SELECT questions.id, title, body, questions.user_id
    FROM 
      questions
    JOIN
      question_followers
    ON
      questions.id = question_followers.question_id
    WHERE
      follower_id = ?
    SQL
    
    questions.map { |question| Question.new(question) }
  end
  
  def create
    QuestionsDatabase.instance.execute(<<-SQL, @question_id, @follower_id)
    INSERT INTO question_followers (question_id, follower_id)
    VALUES
    ( ?, ? )
    SQL
    
    @id = QuestionsDatabase.instance.last_insert_row_id
  end
  
  def self.most_followed_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT questions.id, body, title, user_id
      FROM 
       questions
      JOIN 
       question_followers
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