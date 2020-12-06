load the file
sed 's/^$/123thisisanewline123/g' question_answers.input > questions_thisisanewline.input
cat questions_thisisanewline.input | tr -d '\n' > questions_oneline.input
cat questions_oneline.input | awk -F'123thisisanewline123' '{$1=$1}1' OFS='\n' | awk ' { print "("$0")," } ' | sed "s/(/('/g" | sed "s/)/')/g" > questions_input.sql

create table jp_test_questions(id int identity, answers varchar(500))
