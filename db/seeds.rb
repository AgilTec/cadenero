@account = Cadenero::V1::Account.create!(name: Cadenero.default_account_name, 
                              subdomain: Cadenero.default_account_subdomain, 
                              owner: Cadenero::User.create!(email: Cadenero.default_user_email,
                                                            password: Cadenero.default_user_password, 
                                                            password_confirmation: Cadenero.default_user_password))

@account.create_schema
@account.ensure_authentication_token!