module ApplicationHelper
  def back_link
    tag.span class: 'js-back-link', data: { text: t('back_link') }
  end
end
