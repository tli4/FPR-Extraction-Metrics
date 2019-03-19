class User < ActiveRecord::Base
  rolify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :assign_initial_roles

  private
    def assign_initial_roles
      if self.roles.length == 0
        if User.with_role(:admin).length == 0
          self.add_role :admin
        else
          self.add_role :guest
        end
      end
    end
end
