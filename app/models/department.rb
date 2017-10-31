class Department < ApplicationRecord
  validates_uniqueness_of :deptname, on: :create
  validates_presence_of :deptname
  validates_presence_of :deptschool
end
