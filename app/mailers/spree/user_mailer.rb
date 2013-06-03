begin
require_dependency 'spree/base_mailer'
rescue LoadError
end

superclass = defined?(Spree::BaseMailer) ? Spree::BaseMailer : ActionMailer::Base
class Spree::UserMailer < superclass
  def reset_password_instructions(user)
    @edit_password_reset_url = spree.edit_user_password_url(:reset_password_token => user.reset_password_token)

    subject = Spree::Config[:site_name] + ' ' + I18n.t(:password_reset_instructions)
    mail_params = {:to => user.email, :from => from_address, :subject => subject}
    mail(mail_params)
  end
end
