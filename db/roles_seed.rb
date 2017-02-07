# Pedidos 
# new roles should be added here. DO NOT RUN THIS ON OLD SYSTEMS. 
Role.delete_all
Role.create(name: "Edicion de Pedidos",description: "Edicion de pedidos basica. Resumen de pedidos ", identifier: "bills_edition",role_type: "module")
# Acciones para cada pedido
Role.create(name: "Anulacion facturas", description:"Anulacion de pedidos despues de preparados (no pagos)", identifier: "bills_nullify",role_type: "action")
Role.create(name: "Anulacion facturas en cola", description:"Anulacion de pedidos en cola", identifier: "bills_queue_null",role_type: "action")
Role.create(name: "Pagar facturas",description: "Permite pagar Facturas", identifier: "bills_payment",role_type: "action")
Role.create(name: "Preparar comanda",description: "Permite pasar a preparado una Factura", identifier: "bills_prepared",role_type: "action")
Role.create(name: "Pendiente de pago en facturas", description:"Pasar facturas a pendiente de pago", identifier: "bills_pending",role_type: "action")
Role.create(name: "Imprimir Recibo", description:"Permite imprimir recibo de factura", identifier: "bills_print",role_type: "action")
Role.create(name: "Imprimir Reporte Z", description:"Permite imprimir reporte Z", identifier: "bills_z_report",role_type: "action")
# cocina
Role.create(name: "Ver cocina",description: "Visualizar cocina", identifier: "view_kitchen",role_type: "module")
# administracion de modulos
Role.create(name: "Historicos Pedidos",description: "Reportes de historicos de pedidos", identifier: "bills_reports_history",role_type: "report")
Role.create(name: "Historico Suministros",description: "Reportes de historicos de suministros", identifier: "supplies_history",role_type: "report")
Role.create(name: "Reporte Productos",description: "Reportes de productos actualmente en cola", identifier: "product_report",role_type: "report")
Role.create(name: "Facturas Pendientes",description: "Reporte Facturas Pendientes", identifier: "bills_pending_report",role_type: "report")
Role.create(name: "Facturas Pagadas Hoy",description: "Reporte Facturas Pagadas Hoy", identifier: "bills_today_paid_report",role_type: "report")
Role.create(name: "Cierre de caja", description: "Administracion Cierre de caja", identifier: "closing_stage_management",role_type: "module")
Role.create(name: "Ventas por productos", description: "Ventas por productos", identifier: "closeout_report",role_type: "report")
Role.create(name: "Admon de mesas",description: "Edicion total de mesas", identifier: "tables_management",role_type: "module")
Role.create(name: "Admon de gastos",description: "Administracion de gastos", identifier: "expenses_management",role_type: "module")
Role.create(name: "Admon inventarios",description: "Administracion de inventarios", identifier: "inventories_management",role_type: "module")
Role.create(name: "Admon Usuarios",description: "Administracion de Usuarios", identifier: "users_management",role_type: "module")
Role.create(name: "Admon Configuracion",description: "Permite administrar la configuracion del local", identifier: "settings_management",role_type: "module")
Role.create(name: "Admon Descuentos",description: "Administracion de descuentos", identifier: "discount_management",role_type: "module")
Role.create(name: "Admon Productos",description: "Administracion de productos y suministros", identifier: "product_management",role_type: "module")
Role.create(name: "Admon Cocinas",description: "Administracion de cocinas", identifier: "kitchen_management",role_type: "module")
