# frozen_string_literal: true

# usage
# FastCount.new(User.all).call
# => 826
# FastCount.new(User.where("id > 200")).call
# => 665

class FastCount
  attr_reader :scope, :sql

  def initialize(scope)
    @scope = scope
    @sql = scope.to_sql
  end

  def call
    explain_sql = "explain (format json) #{sql}"
    result = ApplicationRecord.connection.execute(explain_sql)[0]["QUERY PLAN"]
    json = JSON.parse(result)
    json[0]["Plan"]["Plan Rows"].to_i
  end
end
