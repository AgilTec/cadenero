Warden::Strategies.add(:password) do
  def subdomain
    ActionDispatch::Http::URL.extract_subdomains(request.host, 1)
  end

  def valid?
    Rails.logger.info "valid? subdomain: #{subdomain}"
    Rails.logger.info "valid? params: #{params}"
    subdomain.present? && params["user"]
  end
  
  def authenticate!
    Rails.logger.info "subdomain: #{subdomain}"
    account = Cadenero::V1::Account.find_by_subdomain(subdomain)
    Rails.logger.info "account: #{account.to_json}"
    if account
      u = account.users.find_by_email(params["user"]["email"])
      Rails.logger.info "user: #{u.to_json}"
      if u.nil? || u.blank?
        fail!
      else
        Rails.logger.info "authenticate user! not null: #{u.to_json}"
        u.authenticate(params["user"]["password"]) ? success!(u) : fail!
      end
    else
      fail!
    end
  end
end