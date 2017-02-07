module DiscountVouchersHelper

  def render_discounts(discounts)
    return if discounts.empty?
    content_tag(:div, class: 'discount-ocurrence') do
      safe_join(
        discounts.map do |d|
          radio_button_tag(:discount, d.id, false) +
          label_tag("discount_#{d.id}")do
            concat content_tag(:span, d.name)
            concat discount_type(d)
          end
        end
      )
    end
  end

  def discount_type(discount)
    content_tag :span do
      if discount.discount_type == 'val'
        colombian_currency discount.value
      elsif discount.discount_type == 'var'
        number_field_tag(
          'discount_value',
          discount.value ? discount.value : 0, class: 'dsc_var',
          data:{id: discount.id}
        )
      else
        "% #{discount.value}"
      end
    end
  end

end
