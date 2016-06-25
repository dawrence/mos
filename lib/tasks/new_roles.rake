# Please add any new role here. do not run seed roles, just run on new environments.
namespace :roles do
  desc "Adds new roles"
  task :new => [:environment] do
    User.where(role: 2).each do |d|
      d.roles << Role.create(name: "Anulacion facturas en cola", description:"Anulacion de pedidos en cola", identifier: "bills_queue_null",role_type: "action")
      d.roles << Role.create(name: "Ver cocina",description: "Visualizar cocina", identifier: "view_kitchen",role_type: "module")
      d.save
    end
  end
end