#--
# Copyright (c) 2013 AgilTec. Manuel Vidaurre @mvidaurre
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

require "cadenero/engine"
require 'warden'
require 'apartment'

module Cadenero
  mattr_accessor  :base_path,
                  :user_class,
                  :default_account_name,
                  :default_account_subdomain,
                  :default_user_email,
                  :default_user_password

  class << self
    # @return the base path for the Cadenero named routes
    def base_path
      @@base_path ||= Rails.application.routes.named_routes[:cadenero].path
    end

    # defines which class will be used as User Class in Cadenero
    def user_class
      if @@user_class.is_a?(Class)
        raise "You can no longer set Cadenero.user_class to be a class. Please use a string instead."
      elsif @@user_class.is_a?(String)
        begin
          Object.const_get(@@user_class)
        rescue NameError
          @@user_class.constantize
        end
      end
    end
  end

end
