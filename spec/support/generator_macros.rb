module Cadenero
  module GeneratorMacros
    def cleanup!
      Dir.chdir(Rails.root) do
        FileUtils.rm_rf("db/migrate")
      end

      backup_or_restore = "#{example.metadata[:run] ? "restore" : "backup"}_file"
      ["#{Rails.root}/app/controllers/application_controller.rb",
       "#{Rails.root}/config/routes.rb"].each do |file|
        send(backup_or_restore, file)
      end
    end

    def backup_file(file)
      FileUtils.cp(file, file + ".bak")
    end

    def restore_file(file)
      FileUtils.mv(file + ".bak", file)
    end
  end
end

RSpec.configure do |c|
  c.include Cadenero::GeneratorMacros, :example_group => {
    :file_path => c.escaped_path(%w[spec (generators)])
  }
end