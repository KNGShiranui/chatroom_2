module SessionsHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?    #ログインしてるかどうか確認
    current_user.present?
  end
end