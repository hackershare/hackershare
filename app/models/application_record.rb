# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def short_error_message
    errors.full_messages.to_sentence
  end

  def locale_lang
    case I18n.locale
    when :en
      :english
    when :'zh-CN'
      :chinese
    end
  end
end
