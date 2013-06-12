Warden::Strategies.add(:password) do
  def subdomain
    ActionDispatch::Http::URL.extract_subdomains(request.host, 1)
  end

  def valid?
    subdomain.present? && params["user"]
  end
  
  def authenticate!
    account = Cadenero::Account.find_by_subdomain(subdomain)
    if account
      u = account.users.find_by_email(params["user"]["email"])
      if u.nil?
        fail!
      else
        u.authenticate(params["user"]["password"]) ? success!(u) : fail!
      end
    else
      fail!
    end
  end
end