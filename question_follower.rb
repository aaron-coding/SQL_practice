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
end