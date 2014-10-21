class Reply
  attr_accessor :question_id, :follower_id
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
    Reply.new(reply_hash)
  end
end
