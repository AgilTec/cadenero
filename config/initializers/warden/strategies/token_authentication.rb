Warden::Strategies.add(:token_authentication) do
  def subdomain
    ActionDispatch::Http::URL.extract_subdomains(request.host, 1)
  end

  def json_params
    unless params.empty?
      params
    else
      @json ||= env['rack.input'].gets
      JSON.parse(@json)
    end
  end

  def valid?
    subdomain.present? && json_params["auth_token"]
  end

  def authenticate!
    account = Cadenero::V1::Account.get_by_subdomain(subdomain)
    if account
      u = account.members.where(auth_token: json_params["auth_token"]).first.user
      if u.nil? || u.blank?
        fail!
      else
        env['warden'].set_user(u.id, :scope => :user)
        success!(u)
      end
    else
      fail!
    end
  end
end