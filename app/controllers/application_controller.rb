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
    Net::HTTP.post_form(uri, parameters)
    Rails.logger.debug "!!!!!DEBUG: send_answer"
    Rails.logger.debug "!!!!!DEBUG: #{parameters}"
  end

  def first_task(question)
    question.gsub!("\u00a0", " ")
    question.gsub!(/[.,\-!?;:—»«]/, ' ') 

    question.gsub!('  ', ' ')
    question.gsub!(/\A\p{Space}*/, '')
    question.strip!

    answer = $main_hash[question]
    Rails.logger.debug "!!!!!DEBUG: #{answer}"
    answer
  end

  def second_task

  end

  
end



