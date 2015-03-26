require 'spec_helper'

describe 'Lock Account' do
  let(:user) { create :user, password: 'new_password' }

  before do
    @old_max_attempts = Devise.maximum_attempts
    Devise.maximum_attempts = 1

    @old_lock_strategy = Devise.lock_strategy
    Devise.lock_strategy = :failed_attempts

    sign_in_as!(user)
  end

  after do
    Devise.lock_strategy = @old_lock_strategy
    Devise.maximum_attempts = @old_max_attempts
  end

  it 'locks the user account' do
    expect(user.reload).to be_access_locked
  end

  it 'shows validation error' do
    page.should have_content("Invalid email or password")
    page.should have_content("Login")
  end
end
