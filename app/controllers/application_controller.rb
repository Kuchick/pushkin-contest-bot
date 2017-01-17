class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  def index
  end

  def quiz
    question = question_params[:question]
    task_id = question_params[:task_id]
    level = question_params[:level]
    answer = $main_hash[question]

    head :ok, content_type: 'text/html'
    
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
  end

  def first_task
  
    
  end

  
end



