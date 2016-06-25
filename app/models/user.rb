#encoding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :timeoutable,
         :recoverable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  # The role can be either 1: Admin, 2: others
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role, :name, :id_number
  # attr_accessible :title, :body
  has_many :bills
  has_many :expenses
  has_many :privileges
  has_many :roles, through: :privileges
  has_many :user_kitchens
  has_many :kitchens, through: :user_kitchens
  validates :id_number, presence: true,
                        length: { minimum: 8, message: '* La identificación debe ser superior a 8 caracteres.' }
  validates_uniqueness_of :email, message: '* El email: %{value} ya está registrado.'
  validates_uniqueness_of :id_number, message: '* La identificación: %{value} ya está registrada.'

  accepts_nested_attributes_for :privileges, allow_destroy: true

  default_scope order: "users.created_at ASC"

  def mos_id
    self.name or self.id_number or self.email
  end

  def forbidden?(role)
    !roles.map(&:identifier).include?(role.to_s)
  end

  def reset_password
    if self.id_number and self.id_number.to_s.size >= 8
      self.password = self.id_number
      self.password_confirmation = self.id_number
      self.save
      true
    else
      false
    end
  end

  def allowed_kitchen?(kitchen)
    kitchens.map(&:id).include?(kitchen.id)
  end

  def has_role(identifier)
    resutl =!roles.where(identifier: identifier).empty?
    puts resutl
    return resutl
  end

  def print_role
    case self.role
    when 0
      "Super Administrador"
    when 1
      "Cajero"
    when 2
      "Mesero"
    end
  end

end
