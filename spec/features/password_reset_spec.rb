require 'spec_helper'

describe "Reset Password" do
  before do
    @user = create(:user, :email => "foobar@example.com", :password => "secret", :password_confirmation => "secret")
    ActionMailer::Base.default_url_options[:host] = "http://example.com"
  end

  def fill_reset_password_page!
    visit spree.login_path
    click_link "Forgot Password?"
    fill_in "Email", :with => @user.email
    click_button "Reset my password"
    @user.reload.reset_password_token
  end

  it "should allow a user to supply an email for the password reset" do
    fill_reset_password_page!
    page.should have_content("You will receive an email with instructions")
  end

  it "shows errors if no email is supplied" do
    visit spree.login_path
    click_link "Forgot Password?"
    click_button "Reset my password"
    page.should have_content("Email can't be blank")
  end

  it "should show reset page with a valid token" do
    token = fill_reset_password_page!

    visit spree.edit_password_path(reset_password_token: token)
    # Check no redirect
    current_path.should == spree.edit_password_path
  end

  it "should redirect to login if getting an invalid token" do
    visit spree.edit_password_path(reset_password_token: 'this-token-does-not-exist')
    page.should have_content('Given password reset token is either invalid or expired.')
  end

  it "should show reset page with a valid token" do
    token = fill_reset_password_page!
    @user.reset_password_sent_at = 2.days.ago
    @user.save!

    visit spree.edit_password_path(reset_password_token: token)
    page.should have_content('Given password reset token is either invalid or expired.')
  end
end
