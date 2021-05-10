class DailyMailer < ApplicationMailer
  def notify_user
        default to: -> { User.pluck(:email) }
        mail(subject: "everyday Bookers!yay!")
  end
end
