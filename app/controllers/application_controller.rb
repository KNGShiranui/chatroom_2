class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception  # CSRF対策
  include SessionsHelper  # SessionsHelperの適用
  before_action :login_required

  private

  def login_required
    redirect_to new_session_path unless current_user  # カレントユーザー以外はログインを要求
  end
end
