class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_roles

  belongs_to :resource,
             :polymorphic => true

 def readable_roles
   {:admin => "Administrator", :readWrite => "Read/Write",
   :readOnly => "Read Only", :guest => "Guest"}
 end

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify
end
