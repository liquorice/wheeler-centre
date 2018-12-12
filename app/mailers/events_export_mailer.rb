class EventsExportMailer < ActionMailer::Base
  layout "mailer"

  def export(to_email, files)
    files.each do |file|
      name, path = file
      attachments[name] = File.read(path)
    end

    mail_options = {
      to: to_email,
      from: "webmaster@wheelercentre.com",
      subject: "Events export"
    }

    mail(mail_options)
  end
end