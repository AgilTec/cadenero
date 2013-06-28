@account = Cadenero::V1::Account.create!(name: 'Root Account', 
                              subdomain: 'www', 
                              owner: Cadenero::User.create!(email: 'testy@example.com',
                                                            password: '12345678', 
                                                            password_confirmation: '12345678'))

@account.create_schema
@account.ensure_authentication_token!