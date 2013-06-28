require 'spec_helper'
require 'generators/cadenero/install_generator'

describe Cadenero::Generators::InstallGenerator do
  before { cleanup! }
  after { cleanup! }

  # So we can know whether to backup or restore in cleanup!
  # Wish RSpec had a setting for this already
  before { flag_example! }
  def flag_example!
    example.metadata[:run] = true
  end

  def migrations
    Dir["#{Rails.root}/db/migrate/*.rb"].sort
  end

  

  it "seeds the database" do
    Cadenero::V1::Account.count.should == 0
    Cadenero::User.count.should == 0

    FactoryGirl.create(:account)
    FactoryGirl.create(:user)
    Cadenero::Engine.load_seed

    Cadenero::V1::Account.count.should == 2
    Cadenero::User.count.should == 3
  end

end