require 'rails/generators'
module Cadenero
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option "user-class", :type => :string
      class_option "no-migrate", :type => :boolean
      class_option "current-user-helper", :type => :string

      source_root File.expand_path("../install/templates", __FILE__)
      desc "Used to install Cadenero"

      def install_migrations
        puts "Copying over Cadenero migrations..."
        Dir.chdir(Rails.root) do
          `rake cadenero:install:migrations`
        end
      end

      def determine_user_class
        @user_class = options["user-class"].presence ||
                      ask("What is your user class called? [User]").presence ||
                      'User'
      end

      def determine_current_user_helper
        current_user_helper = options["current-user-helper"].presence ||
                              ask("What is the current_user helper called in your app? [current_user]").presence ||
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

      def run_migrations
        unless options["no-migrate"]
          puts "Running rake db:migrate"
          `rake db:migrate`
        end
      end

      def seed_database
        load "#{Rails.root}/config/initializers/cadenero.rb"
        unless options["no-migrate"]
          puts "Creating default cadenero account and owner"
          Cadenero::Engine.load_seed
        end
      end

      def mount_engine
        puts "Mounting Cadenero::Engine at \"/\" in config/routes.rb..."
        insert_into_file("#{Rails.root}/config/routes.rb", :after => /routes.draw.do\n/) do
          %Q{
  # This line mounts Cadenero's routes at / by default.
  # This means, any requests to the / URL of your application will go to Cadenero::V1:Account::DashboardController#index.
  # If you would like to change where this extension is mounted, simply change the :at option to something different
  # but that is discourage, the idea is to protect the whole site
}
        end
      end

      def finished
        output = "\n\n" + ("*" * 53)
        output += %Q{\nDone! Cadenero has been successfully installed. Yaaaaay! He will keep the intoxicated JSON's out

Here's what happened:\n\n}

        output += step("Cadenero's migrations were copied over into db/migrate.\n")
        output += step("We created a new migration called AddCadeneroAdminToTable.
   This creates a new field called \"cadenero_admin\" on your #{user_class} model's table.\n")
        output += step("A new method called `cadenero_user` was inserted into your ApplicationController.
   This lets Cadenero know what the current user of your application is.\n")
        output += step("A new file was created at config/initializers/cadenero.rb
   This is where you put Cadenero's configuration settings.\n")

        unless options["no-migrate"]
output += step("`rake db:migrate` was run, running all the migrations against your database.\n")
        output += step("Seed forum and topic were loaded into your database.\n")
        end
        output += step("The engine was mounted in your config/routes.rb file using this line:

   mount Cadenero::Engine, :at => \"/\"

   If you want to change where the forums are located, just change the \"/forums\" path at the end of this line to whatever you want.")
        output += %Q{\nAnd finally:

#{step("We told you that Cadenero has been successfully installed and walked you through the steps.")}}
        unless defined?(Devise)
          output += %Q{We have detected you're not using Devise (which is OK with us, really!), so there's one extra step you'll need to do.

   You'll need to define a "sign_in_path" method for Cadenero to use that points to the sign in path for your application. You can set Cadenero.sign_in_path to a String inside config/initializers/cadenero.rb to do this, or you can define it in your config/routes.rb file with a line like this:

          get '/users/sign_in', :to => "users#sign_in"

   Either way, Cadenero needs one of these two things in order to work properly. Please define them!}
        end
        output += "\nIf you have any questions, comments or issues, please post them on our issues page: http://github.com/AgilTec/cadenero/issues.\n\n"
        output += "Thanks for using Cadenero!"
        puts output
      end

      private

      def step(words)
        @step ||= 0
        @step += 1
        "#{@step}) #{words}\n"
      end

      def user_class
        @user_class
      end

      def next_migration_number
        last_migration = Dir[Rails.root + "db/migrate/*.rb"].sort.last.split("/").last
        current_migration_number = /^(\d+)_/.match(last_migration)[1]
        current_migration_number.to_i + 1
      end
    end
  end
end