Warden::Strategies.add(:password) do
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
    subdomain.present? && json_params["user"]
  end
  
  def authenticate!
    account = Cadenero::V1::Account.find_by_subdomain(subdomain)
    if account
      u = account.users.find_by_email(json_params["user"]["email"])
      if u.nil? || u.blank?
        fail!
      else
        u.authenticate(json_params["user"]["password"]) ? success!(u) : fail!
      end
    else
      fail!
    end
  end
end