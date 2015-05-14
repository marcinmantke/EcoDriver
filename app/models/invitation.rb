class Invitation < ActiveRecord::Base
  belongs_to :invited_by, class_name: 'User'
  belongs_to :user
  belongs_to :challenge
end
