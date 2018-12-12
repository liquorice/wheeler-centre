class EventsExportMailer < ActionMailer::Base
  layout "mailer"

  def export(files)
    files.each do |file|
      name, path = file
      attachments[name] = File.read(path)
    end

    mail_options = {
      to: "max@icelab.com.au",
      from: "max@icelab.com.au",
      subject: "Events export"
    }

    mail(mail_options)
  end
end