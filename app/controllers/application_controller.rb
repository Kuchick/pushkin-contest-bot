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
    answer = $main_hash[question]

    question.gsub!(';', ' ')
    question.gsub!(':', ' ')
    #question.gsub!('', ' ')

    question.gsub!(',', ' ')
    question.gsub!('?', ' ')
    question.gsub!('!', ' ')
    question.gsub!('-', ' ')
    question.gsub!('.', ' ')
    question.gsub!('  ', ' ')
    question.gsub!(/\A\p{Space}*/, '')
    question.strip!
    

    Rails.logger.debug "!!!!!DEBUG: #{params}"
    Rails.logger.debug "!!!!!DEBUG: #{answer}"

    send_answer(answer, task_id)
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

  def first_task
  
    
  end

  
end



