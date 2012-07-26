# Skeletal ActiveRecord representation of OLAb user profile record.
# This is needed only to do three things:  a) connect to the UUM user database, b) lookup record by email
# c) check password.
#
class User < ActiveRecord::Base
  attr_accessible :email, :password_digest
end




# Custom authenticator module for use in OLab RubyCAS implementation
# Code should be fairly self-explanatory.
require 'casserver/authenticators/base'
require 'bcrypt'


require 'casserver/authenticators/google'

class OLabGoogleAuthenticator < CASServer::Authenticators::Google

  def extra_attributes

    @extra_attributes[:staff] = "true"

    @extra_attributes
  end

end


class OLabDatabaseAuthenticator < CASServer::Authenticators::Base


  def self.setup(options)
    super(options)

    # Establish connection to UUM profile db using AR semantics.
    User.establish_connection options["database"]
  end


  def validate(credentials)
    read_standard_credentials(credentials)

    # Email is used as the unique profile identifier in this system ... locate the appropriate profile using
    # the supplied email address.
    u = User.find_by_email @username

    # If no match by email, then there obviously can't be a successful check.  Fall-thru to allow a
    # nil return, which will signal failure to the CAS server.
    if u
      # Retrieve the plaintext password from the digest stored on the user profile record.
      db_password = BCrypt::Password.new u.password_digest

      # Compare retrieved p/w with supplied p/w.  If matching, return user profile object.

      if db_password == @password

        # Fill in extra attributes.
        extra_attributes_to_extract.each do |attr|
          @extra_attributes[attr] = u.send(attr)
        end

        return u
      end

    end

    # ensure a false return to CAS if gotten this far
    false
  end

end
