require_relative 'interface'
User.new({'fname' => 'Iron', 'lname' => 'Man'}).create
User.new({'fname' => 'Joe', 'lname' => 'Brown'}).create
User.new({'fname' => 'Jane', 'lname' => 'Eyre'}).create
User.new({'fname' => 'Frodo', 'lname' => 'Baggins'}).create
Question.new({'title' => "Why don't more people play the banjo?", 'body' => "I must know",
                          'user_id'=> 1}).create
Question.new({'title' => "Why do people smell?", 'body' => "I must know",
            'user_id'=> 2}).create                          
Question.new( { 'title' => "Why is the sky blue?",
                     'body'  => "For real.. WHY?!",
                     'user_id' => 1 }).create


r1 = Reply.new({ 'question_id' => 1, 'user_id' => 2,
 'body' => 'Showers.  They have none.' }).create

QuestionFollower.new({
    "question_id" => 1,
    "follower_id" => 3
  }).create
  
QuestionFollower.new({
    "question_id" => 1,
    "follower_id" => 4
  }).create
    
QuestionFollower.new({
    "question_id" => 1,
    "follower_id" => 6
  }).create
  
QuestionFollower.new({
    "question_id" => 2,
    "follower_id" => 6
  }).create
  
QuestionFollower.new({
    "question_id" => 2,
    "follower_id" => 4
  }).create
  
QuestionLike.new({
  "question_id" => 1,
  "user_id" => 2 
}).create

QuestionLike.new({
  "question_id" => 2,
  "user_id" => 1 
}).create

QuestionLike.new({
  "question_id" => 3,
  "user_id" => 3 
}).create

QuestionLike.new({
  "question_id" => 3,
  "user_id" => 4 
}).create

QuestionLike.new({
  "question_id" => 3,
  "user_id" => 5 
}).create

QuestionLike.new({
  "question_id" => 3,
  "user_id" => 6 
}).create