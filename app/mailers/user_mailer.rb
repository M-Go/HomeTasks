class UserMailer < ApplicationMailer
  def petition_accepted(petition)
    @petition = petition
    @user = petition.user
    mail to: @user.email, subject: 'Petition accepted'
  end
end
