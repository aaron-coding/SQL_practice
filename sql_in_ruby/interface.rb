require_relative 'questions_database'
require_relative 'question'
require_relative 'user'
require_relative 'question_follower'
require_relative 'question_like'
require_relative 'reply'



#p QuestionLike.liked_questions_for_user_id(1)
# p Question.most_followed(3)
# p QuestionFollower.most_followed_questions(2)


u1 = User.find_by_id(1)

p u1.instance_variables


