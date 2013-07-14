require 'rails/generators'
module Cadenero
  # Bootstrap Cadenero in a new Rails App
  module Generators
    # Cadenero generator to be used as `rails-api g cadenero:install`
    class InstallGenerator < Rails::Generators::Base 
      class_option "user-class", :type => :string
      class_option "default-account-name", :type => :string
      class_option "default-account-subdomain", :type => :string
      class_option "default-user-email", :type => :string
      class_option "default-user-password", :type => :string
      class_option "no-migrate", :type => :boolean
      class_option "current-user-helper", :type => :string

      source_root File.expand_path("../install/templates", __FILE__)
      desc "Used to install Cadenero"

      # Copy the Cadenero Migrations in the New App
      def install_migrations
        puts "Copying over Cadenero migrations..."
        Dir.chdir(Rails.root) do
          `rake cadenero:install:migrations`
        end
      end

      # Defines which class will be used as User Class for Cadenero
      def determine_user_class
        @user_class = options["user-class"].presence ||
                      ask("What will be the name for your user class? [User]").presence ||
                      'User'
      end

      # Defines which helper will be used as User Class Helper for Cadenero and inject that in the application_controller.rb
      def determine_current_user_helper
        current_user_helper = options["current-user-helper"].presence ||
                              ask("What will be the current_user helper called in your app? [current_user]").presence ||
                              :current_user

        puts "Defining cadenero_user method inside ApplicationController..."

        cadenero_user_method = %Q{
  def cadenero_user
    #{current_user_helper}
  end
  helper_method :cadenero_user

}

        inject_into_file("#{Rails.root}/app/controllers/application_controller.rb",
                         cadenero_user_method,
                         :after => "ActionController::API\n")

      end

      # Define which will be the Root Account for the Multitnant Rails App
      def determine_default_account_name
        Cadenero.default_account_name = options["default-account-name"].presence ||
                      ask("What will be the name for the default account? [Root Account]").presence ||
                      'Root Account'
      end

      # Define which will be the root subdomain for the Multitnant Rails App. (Default: www)
      def determine_default_account_subdomain
        Cadenero.default_account_subdomain = options["default-account-subdomain"].presence ||
                      ask("What will be the subdomain for the default account? [www]").presence ||
                      'www'
      end

      # Define which will be the root owner for the defaul accout Multitnant Rails App.
      def determine_default_user_email
        Cadenero.default_user_email = options["default-user-email"].presence ||
                      ask("What will be the email for the default user owner of the default account? [testy@example.com]").presence ||
                      'testy@example.com'
      end

      # Define which will be the password for the root owner for the defaul accout Multitnant Rails App.
      def determine_default_user_password 
        Cadenero.default_user_password  = options["default-user-password"].presence ||
                      ask("What will be the password for the default user owner of the default account? [change-me]").presence ||
                      'change-me'
      end

      # Create the Cadenero initilizar based on the Template.
      def add_cadenero_initializer
        path = "#{Rails.root}/config/initializers/cadenero.rb"
        if File.exists?(path)
          puts "Skipping config/initializers/cadenero.rb creation, as file already exists!"
        else
          puts "Adding cadenero initializer (config/initializers/cadenero.rb)..."
          template "initializer.rb", path
          require path # Load the configuration per issue #415
        end
      end

      # Run the Cadenero Migrations in the New App
      def run_migrations
        unless options["no-migrate"]
          puts "Running rake db:migrate"
          `rake db:migrate`
        end
      end

      # Seed the databas using the options selected as defaults
      def seed_database
        puts "default_account_name: #{Cadenero.default_account_name}"
        puts "default_account_subdomain: #{Cadenero.default_account_subdomain}"
        puts "default_user_email: #{Cadenero.default_user_email}"
        puts "default_user_password: #{Cadenero.default_user_password}"
  
        load "#{Rails.root}/config/initializers/cadenero.rb"
        unless options["no-migrate"]
          puts "Creating default cadenero account and owner"
          Cadenero::Engine.load_seed
        end
      end

      # Injects the code in the `routes.rb` for mounting the Cadenero Engine
      def mount_engine
        puts "Mounting Cadenero::Engine at \"/\" in config/routes.rb..."
        insert_into_file("#{Rails.root}/config/routes.rb", :after => /routes.draw.do\n/) do
          %Q{
  mount Cadenero::Engine, :at => "/" # This line mounts Cadenero's routes at / by default.
  # This means, any requests to the / URL of your application will go to Cadenero::V1:Account::DashboardController#index.
  # If you would like to change where this extension is mounted, simply change the :at option to something different
  # but that is discourage, the idea is to protect the whole site

}
        end
      end

      # Wrap-ups the installation giving appropiate messages
      def finished
        output = "\n\n" + ("*" * 53)
        output += %Q{\nDone! Cadenero has been successfully installed. Yaaaaay! He will keep the intoxicated JSON's out

Here's what happened:\n\n}

        output += step("Cadenero's migrations were copied over into db/migrate.\n")
        output += step("A new method called `cadenero_user` was inserted into your ApplicationController.
   This lets Cadenero know what the current user of your application is.\n")
        output += step("A new file was created at config/initializers/cadenero.rb
   This is where you put Cadenero's configuration settings.\n")

        unless options["no-migrate"]
output += step("`rake db:migrate` was run, running all the migrations against your database.\n")
        output += step("Seed account and user were loaded into your database.\n")
        end
        output += step("The engine was mounted in your config/routes.rb file using this line:

   mount Cadenero::Engine, :at => \"/\"

   If you want to change where the forums are located, just change the \"/\" path at the end of this line to whatever you want.")
        output += %Q{\nAnd finally:

#{step("We told you that Cadenero has been successfully installed and walked you through the steps.")}}
        output += "\nIf you have any questions, comments or issues, please post them on our issues page: http://github.com/AgilTec/cadenero/issues.\n\n"
        output += "Thanks for using Cadenero!"
        puts output
      end

      private

      # Keep track of the step number for the installation process
      def step(words)
        @step ||= 0
        @step += 1
        "#{@step}) #{words}\n"
      end

      # @return the user_class
      def user_class
        @user_class
      end


    end
  end
end