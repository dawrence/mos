module PrivilegesHelper
    def report_options
        a = []
        a << ["Reporte de Facturas", "bills_report_view"] if allowed? :bills_reports_history
        a << ["Resumen de Productos", "products_overview"] if allowed? :product_report
        a << ["Resumen de Suministros", "supplies_overview"] if allowed? :supplies_history
        a
    end

    def sales_options
        a = []
        a << ["Resumen de Pedidos", "bills_overview"] if allowed? :bills_edition
        a << ["Facturas Pendientes", "bills_pending_overview"] if allowed? :bills_pending
        a << ["Facturas Pagadas Hoy", "bills_paid_overview"] if allowed? :bills_today_paid_report
        a << ["Cierre de Caja", "closing_stage"] if allowed? :closing_stage_management
        a << ["Ventas por Productos", "closeout_view"] if allowed? :closeout_report
        a
    end
end