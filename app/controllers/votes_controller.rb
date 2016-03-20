class VotesController

  def create
    vote = current_user.votes.create(votes_params)
    redirect_to vote.petition, notice: 'Спасибо, Ваш голос учтен!'
    UserMailer.petition_accepted(petition).deliver_later
  end

  private
  def votes_params
    params.permit(:petition_id)
  end

end