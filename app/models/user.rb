class User < ApplicationRecord
  attr_accessor :suadpassword
  validates_presence_of :uname, on: :create
  validates_presence_of :uemail, on: :create
  validates_presence_of :udept, on: :create
  validates_uniqueness_of :uname, on: :create

end
