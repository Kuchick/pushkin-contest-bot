class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  def index
  end

  def quiz
    head :ok, content_type: 'text/html'
    question = question_params[:question]
    task_id = question_params[:id]
    level = question_params[:level]
    if level == 1
      send_answer(first_task(question), task_id)
    elsif level == 2
      send_answer(second_task(question), task_id)
    elsif level == 3
      send_answer(third_task(question), task_id)
    elsif level == 4
      send_answer(fourth_task(question), task_id)
    elsif level == 5
      send_answer(fifth_task(question), task_id)
    end
  end

  def question_params
    params.permit(:question, :id, :level)
  end

  def send_answer(answer, task_id)
    uri = URI('http://pushkin.rubyroidlabs.com/quiz')
    parameters = {
      answer: answer,
      token: '86f13a0f77fc65a43feef10900c5a721',
      task_id:  task_id
    }
    responce = Net::HTTP.post_form(uri, parameters)
    Rails.logger.debug "\n\n\n!!!!!DEBUG: #{responce}"
    Rails.logger.debug "!!!!!DEBUG: send_answer"
    Rails.logger.debug "!!!!!DEBUG: #{parameters}"
  end

  def first_task(question)
    answer = $main_hash[clearing_question(question)]
    #Rails.logger.debug "!!!!!DEBUG: #{answer}"
    answer
  end

  def second_task(question)
    answer = $super_hash[clearing_question(question)]
    #Rails.logger.debug "!!!!!DEBUG: #{answer}"
    answer
  end

  def third_task(question)
    first_part, second_part = question.split("\n")
    answer = $super_hash[clearing_question(first_part)] +
     ',' +  $super_hash[clearing_question(second_part)]
    answer
  end

  def fourth_task(question)
    first_part, second_part, third_part = question.split("\n")
    answer = $super_hash[clearing_question(first_part)] +
     ',' +  $super_hash[clearing_question(second_part)] + 
     ',' + $super_hash[clearing_question(third_part)]
    answer
  end

  def fifth_task(question)
    question = clearing_question(question)
    array = question.split(' ')
    combinations = []
    0.upto(array.size - 1) do |i|
      array_with_word = question.split(' ')
      array_with_word[i] = "%WORD%"
      combinations << (array_with_word.join(" "))
    end
    array_with_nil_and_answer = []
    combinations.each do |elem|
      array_with_nil_and_answer << $super_hash[elem]
    end

    position = 0
    answer = nil
      0.upto(array_with_nil_and_answer.size - 1) do |i|
      if !array_with_nil_and_answer[i].nil?
        position += i
        answer = array_with_nil_and_answer[i]
      end
    end
    answer + ',' + array[position]
  end


  def clearing_question(question)
    question.gsub!("\u00a0", " ")
    question.gsub!(/[.,\-!?;:—»«]/, ' ') 

    question.gsub!('  ', ' ')
    question.gsub!(/\A\p{Space}*/, '')
    question.strip!
    question
  end

  
end



