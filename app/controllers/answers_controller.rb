class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question
  before_action :find_and_authorize_answer, only: :destroy

  # include QuestionsAnswersHelper
  # helper_method :user_like

  def create
    #to make sure that the question_id exit and
    #finding record do not need to use strong params
    @question = Question.find params[:question_id]
    #below is strong Parameters which only use for creating record
    answer_params = params.require(:answer).permit([:body])
    #create new record but wont create question_id
    @answer = Answer.new answer_params
    #create question_id in this answer record
    @answer.question = @question
    @answer.user = current_user
    respond_to do |format|
        if @answer.save
        # render json: params
        AnswersMailer.notify_question_owner(@answer).deliver_later
        format.html {redirect_to question_path(@question), notice: "Thank you for answering"}
        format.js {render :create_success}
        else
        flash[:alert] = "not saved"
        # this will render the show.html.erb inside views/questions
        format.html {render "/questions/show"}
        format.js { render :create_failure }
      end
    end
  end

  def destroy
    #find the question otherwise cant go back
    # question = Question.find params[:question_id]
    # #to delete answer only the answers in that question
    # answer = question.answers.find params[:id]
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to question_path(@question), notice: "Answer deleted!" }
      format.js { render :destroy}
    end
  end

  def edit
    @answer = Answer.find params[:id]
  end


  def find_question
    @question = Question.find params[:question_id]
  end

  def find_and_authorize_answer
     @answer = @question.answers.find params[:id]
     # head will stop the HTTP request and send a response code depending on the
     # symbole (first argument) that you pass in.
     # head :unauthorized unless can? :destroy, @answer
     redirect_to root_path unless can? :destroy, @answer
   end

end
