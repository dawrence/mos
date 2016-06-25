class GeneralMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.general_mailer.report.subject
  #
  def report target, author, action, opts
    @author = author
    @action = action
    @opts = opts

    mail to: target
  end
end
