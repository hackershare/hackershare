# frozen_string_literal: true

module Util
  def self.escape_quote(str)
    str.gsub(/'/, { "'" => "\\'" })
  end

  def self.to_pg_array(array)
    PG::TextEncoder::Array.new.encode(array.presence || []).force_encoding("utf-8")
  end
end
