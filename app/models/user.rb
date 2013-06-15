class User < ActiveRecord::Base
  attr_accessor :password
  belongs_to :partnership
  #has_one :partnership

  before_save do
    self.hashed_password = self.class.encrypt(self.password) if self.password.present?
  end

  class << self
    def find_by_email_and_password(email, password)
      User.where(email: email, hashed_password: encrypt(password)).first
    end

    def encrypt(password)
      Digest::SHA1.hexdigest(password)
    end
  end

  def create_bottle(params)
    Bottle.create(params) do |bottle|
      bottle.owner = self
    end
  end
end
