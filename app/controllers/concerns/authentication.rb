module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :resume_session      # <- always run
    before_action :require_authentication
    helper_method :authenticated?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
      # we do NOT skip :resume_session – we still want Current.session/User!
    end
  end

  private

  def authenticated?
    Current.session.present?
  end

  # --- runs on every request ---
  def resume_session
    Current.session ||= find_session_by_cookie
  end

  def find_session_by_cookie
    sid = cookies.signed[:session_id]
    sid ? Session.find_by(id: sid) : nil
  end

  # --- only redirects when needed ---
  def require_authentication
    return if Current.session.present?

    session[:return_to_after_authenticating] = request.url
    redirect_to new_session_path
  end

  def after_authentication_url
    session.delete(:return_to_after_authenticating) || root_url
  end

  def start_new_session_for(user)
    user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |s|
      Current.session = s
      cookies.signed.permanent[:session_id] = { value: s.id, httponly: true, same_site: :lax }
    end
  end

  def terminate_session
    Current.session&.destroy
    cookies.delete(:session_id)
    Current.session = nil
  end
end
