class User
  attr_accessor :fname, :lname
  attr_reader   :id

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def authored_questions
    Question.find_by_author_id(@id)
    # query = <<-SQL
    # SELECT
    # *
    # FROM
    # questions
    # WHERE
    # user_id = ?
    # SQL
    # questions = QuestionsDatabase.instance.execute(query, @id)
    # questions.map { |hash| Question.new(hash) }
  end
  
  def authored_replies
    query = <<-SQL
    SELECT
    *
    FROM
    replies
    WHERE
    user_id = ?
    SQL

    replies = QuestionsDatabase.instance.execute(query, @id)
    replies.map { |hash| Question.new(hash) }
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
    User.new(user_hash.first)
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
  
  def save
    if self.id.nil?
      create
    else
      update
    end
  end

  def update
    QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
    UPDATE
    users
    SET fname = ?, lname = ?
    WHERE id = ?
    SQL
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
    self
  end
  
  def followed_questions
    QuestionFollower.followed_questions_for_user_id(@id)
  end
  
  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end
  
  def average_karma
    avg_karma =QuestionsDatabase.instance.execute(<<-SQL, @id)
    SELECT
      (CAST(COUNT(question_likes.id) AS FLOAT) / 
      COUNT(DISTINCT questions.id)) AS avg
    FROM
      questions
    JOIN
      question_likes
    ON
      question_id = questions.id
    WHERE 
      questions.user_id = ?
    GROUP BY 
      questions.user_id
    SQL
    avg_karma.first['avg']
  end
  
end


