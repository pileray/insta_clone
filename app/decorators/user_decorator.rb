class UserDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  # rubocop:disable Metrics/MethodLength:
  def avatar(size = :default)
    return 'https://mdbcdn.b-cdn.net/img/new/avatars/2.webp' if profile_image.blank?

    size =  case size
            when :thumb
              { resize_to_fill: [48, 48] }
            when :lg
              { resize_to_fill: [100, 100] }
            else
              false
            end

    image = size ? profile_image.variant(size).processed : profile_image
    h.rails_storage_proxy_url(image, only_path: true)
  end
end
