require_relative 'questions_database'
require_relative 'question'
require_relative 'user'
require_relative 'question_follower'
require_relative 'question_like'
require_relative 'reply'


# User.new({'fname' => 'Iron', 'lname' => 'Man'})
# User.new({'fname' => 'Joe', 'lname' => 'Brown'}).create
#
# User.find_by_name("Joe", "Brown")

q1 = Question.new({'title' => "Why do people smell?", 'body' => "I must know", 
              'user_id'=> 2}).create
q2 = Question.new({'title' => "Why don't more people play the banjo?", 'body' => "I must know", 
                            'user_id'=> 1}).create

r1 = Reply.new({ 'question_id' => 1, 'user_id' => 2,
            'body' => 'Showers.  They have none.' }).create

                            
p Question.all[0].replies
                          