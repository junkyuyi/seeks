class User < ActiveRecord::Base
	EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i

	has_many :secrets
	has_many :likes, dependent: :destroy
	has_many :secrets_liked, through: :likes, source: :secret

	has_secure_password
	validates :name, :email, presence: true
	validates :email, :uniqueness => true, :format => { :with => EMAIL_REGEX }
	before_validation :downcase_email

	private
	def downcase_email
		self.email.downcase! unless self.email.blank?
	end
end