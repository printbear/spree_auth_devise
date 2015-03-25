class Spree::UnlocksController < Devise::UnlocksController

  protected
  def after_unlock_path_for(resource)
    new_spree_user_session_path if is_navigational_format?
  end
end
