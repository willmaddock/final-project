class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile
  before_action :set_comment, only: [:destroy, :upvote]

  # POST /profiles/:profile_id/comments
  def create
    @comment = @profile.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @profile, notice: 'Comment was successfully added.'
    else
      flash[:alert] = @comment.errors.full_messages.to_sentence
      redirect_to @profile
    end
  end

  # DELETE /profiles/:profile_id/comments/:id
  def destroy
    if authorized_to_modify_comment?
      @comment.destroy
      redirect_to @profile, notice: 'Comment was deleted.'
    else
      redirect_to @profile, alert: 'Not authorized to delete this comment.'
    end
  end

  # POST /profiles/:profile_id/comments/:id/upvote
  def upvote
    if current_user.voted_for?(@comment)
      redirect_to @profile, alert: 'You have already upvoted this comment.'
    else
      @comment.liked_by current_user
      redirect_to @profile, notice: 'Comment upvoted.'
    end
  end

  private

  # Sets the profile object for the current comment's context
  def set_profile
    @profile = Profile.find(params[:profile_id])
  end

  # Sets the specific comment by finding it through the profile
  def set_comment
    @comment = @profile.comments.find(params[:id])
  end

  # Strong parameters for comment creation
  def comment_params
    params.require(:comment).permit(:body)
  end

  # Checks if the user is authorized to modify the comment
  def authorized_to_modify_comment?
    @comment.user == current_user || current_user.admin?
  end
end