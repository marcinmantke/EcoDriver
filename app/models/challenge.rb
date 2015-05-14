class Challenge < ActiveRecord::Base
  belongs_to :route, class_name: 'Trip'
  has_many :trips
  has_many :users, through: :challengesuser
  has_many :invitations
end
