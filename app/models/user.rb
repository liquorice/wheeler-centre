class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def heracles_admin?
    true
  end

  def heracles_superadmin?
    true
  end

  def heracles_admin_name
    email
  end
end
