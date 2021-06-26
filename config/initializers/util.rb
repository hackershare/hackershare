# frozen_string_literal: true

module Util
  def self.escape_quote(str)
    return "" if str.nil?
    str.gsub(/'/, {"'" => "\\'"})
  end

  def self.to_pg_array(array)
    PG::TextEncoder::Array.new.encode(array.presence || []).force_encoding("utf-8")
  end

  def self.stop_words
    %w[
      http
      https
      HTTP
      HTTPS
      com
      www
      cn
      en
      blog
    ]
  end

  def self.stop_words_for_where
    stop_words.map do |word|
      "'#{escape_quote(word)}'"
    end.join(", ")
  end
end
