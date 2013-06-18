ActiveRecord::Base.class_eval do
  def self.scoped_to_account
    belongs_to :account, :class_name => "Cadenero::V1::Account"
    association_name = self.to_s.downcase.pluralize
    Cadenero::V1::Account.has_many association_name, :class_name => self.to_s
  end
end