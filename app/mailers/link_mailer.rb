class LinkMailer < BaseMandrillMailer
  def recommend(link, to_email)
    subject = "You have a link recommendation!"
    body = "Your friend on Spinboard Deluxe recommended the following link:\n" \
      "\n <a href=\"#{link.url}\">#{link.title}</a>"

    send_mail(to_email, subject, body)
  end
end
