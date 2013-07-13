require 'spec_helper'
require 'generators/cadenero/install_generator'

describe Cadenero::Generators::InstallGenerator do
  before { cleanup! }
  after { cleanup! }

  # So we can know whether to backup or restore in cleanup!
  # Wish RSpec had a setting for this already
  before { flag_example! }

  # For the example flag its run metadata to true
  def flag_example!
    example.metadata[:run] = true
  end

  # Sort the migrations
  def migrations
    Dir["#{Rails.root}/db/migrate/*.rb"].sort
  end

  it "runs the installer correctly" do
    migrations.should be_empty
    capture(:stdout) do
      described_class.start(["--user-class=User", "--no-migrate", "--current-user-helper=current_user", 
        "--default-account-name=Root", "--default-account-subdomain=www", "--default-user-email=testy@example.com",
        "--default-user-password=change-me"], :destination => Rails.root)
    end

    # Ensure cadenero migrations have been copied over
    migrations.should_not be_empty

    # Ensure initializer has been created
    #cadenero_initializer = File.readlines("#{Rails.root}/config/initializers/cadenero.rb")
    #cadenero_initializer[0].strip.should == %q{Cadenero.user_class = "User"}

    # Ensure cadenero_user is added to ApplicationController
    application_controller = File.read("#{Rails.root}/app/controllers/application_controller.rb")
    expected_cadenero_user_method = %Q{
  def cadenero_user
    current_user
  end
  helper_method :cadenero_user

}
    expect(application_controller).to include(expected_cadenero_user_method)
    expect(Cadenero::V1::Account.count).to eq 0
    expect(Cadenero::User.count).to eq 0

    FactoryGirl.create(:account)
    FactoryGirl.create(:user)
    Cadenero::Engine.load_seed

    expect(Cadenero::V1::Account.count).to eq 2
    expect(Cadenero::User.count).to eq  3
  end

  it "should add /config/initializers/cadenero.rb with Template if doesn't exist" do
    FileUtils.rm("#{Rails.root}/config/initializers/cadenero.rb")
    subject.add_cadenero_initializer
    expect(File.exist?("#{Rails.root}/config/initializers/cadenero.rb")).to be_true 
    cadenero_initializer = File.read("#{Rails.root}/config/initializers/cadenero.rb")
    expect(cadenero_initializer).to include("Cadenero.user_class =")
  end

  it "should run the Cadenero migrations" do
    subject.run_migrations
    expect(Cadenero::User.columns.map{|column| {name: column.name}}).to eq [{:name=>"id"}, 
                                                                            {:name=>"email"}, 
                                                                            {:name=>"password_digest"}, 
                                                                            {:name=>"created_at"}, 
                                                                            {:name=>"updated_at"}]
  end

end