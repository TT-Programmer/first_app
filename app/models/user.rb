class User < ActiveRecord::Base
	validates :name, :length => { :minimum => 8, :maximum => 12}
	validates :password, :length => {:minimum => 4}
	has_many :microposts, dependent: :destroy
end
