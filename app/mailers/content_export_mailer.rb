class ContentExportMailer < ActionMailer::Base
  layout "mailer"

  def export(to_email, files)

    mail_options = {
      to: to_email,
      from: "webmaster@wheelercentre.com",
      subject: "Content export"
    }

    @files = files

    mail(mail_options)
  end
end