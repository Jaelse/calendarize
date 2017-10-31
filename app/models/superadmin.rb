class Superadmin < ApplicationRecord
  attr_accessor :suadpassword
  validates_confirmation_of :suadpassword
  validates_presence_of :suadpassword, on: :create
  validates_presence_of :suadusername
  validates_uniqueness_of :suadusername
  before_save :hash_password


  def self.authenticate(suadusername, suadpassword)
    puts suadusername
    user = find_by_suadusername(suadusername)
    if user && user.suadpassword_hash == BCrypt::Engine.hash_secret(suadpassword, user.suadpassword_salt)
      user
    else
      nil
    end
  end

  def hash_password
    if suadpassword.present?
      self.suadpassword_salt = BCrypt::Engine.generate_salt
      self.suadpassword_hash = BCrypt::Engine.hash_secret(suadpassword, suadpassword_salt)
    end
  end
end
