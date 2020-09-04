# frozen_string_literal: true

module Util
  def self.escape_quote(str)
    str.gsub(/'/, { "'" => "\\'" })
  end
end
