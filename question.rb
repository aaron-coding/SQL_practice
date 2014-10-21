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
end