# frozen_string_literal: true

# == Schema Information
#
# Table name: bookmark_stats
#
#  id          :bigint           not null, primary key
#  date_type   :string           default("daily")
#  dups_count  :integer          default(0)
#  likes_count :integer          default(0)
#  score       :integer
#  bookmark_id :bigint
#  date_id     :date
#
# Indexes
#
#  index_bookmark_stats_on_bookmark_id                            (bookmark_id)
#  index_bookmark_stats_on_date_id_and_date_type_and_bookmark_id  (date_id,date_type,bookmark_id) UNIQUE
#  index_bookmark_stats_on_date_id_and_date_type_and_score        (date_id,date_type,score)
#
class BookmarkStat < ApplicationRecord
  belongs_to :bookmark
  enum date_type: %w[daily weekly monthly].map { |name| [name, name] }.to_h

  def self.dt_params
    daily_dt   = Date.today
    weekly_dt  = daily_dt.beginning_of_week
    monthly_dt = daily_dt.beginning_of_month
    {
      daily: daily_dt,
      weekly: weekly_dt,
      monthly: monthly_dt
    }
  end

  def self.incr_dups_count(bookmark_id)
    dt_params.each do |dt_type, dt|
      incr_dups_count_by_dt(dt_type, dt, bookmark_id)
    end
  end

  def self.incr_likes_count(bookmark_id)
    dt_params.each do |dt_type, dt|
      incr_likes_count_by_dt(dt_type, dt, bookmark_id)
    end
  end

  def self.decr_dups_count(bookmark_id)
    dt_params.each do |dt_type, dt|
      BookmarkStat.where(date_type: dt_type, date_id: dt, bookmark_id: bookmark_id).update_all("dups_count = dups_count -1")
    end
  end

  def self.decr_likes_count(bookmark_id)
    dt_params.each do |dt_type, dt|
      BookmarkStat.where(date_type: dt_type, date_id: dt, bookmark_id: bookmark_id).update_all("likes_count = likes_count -1")
    end
  end

  def self.incr_dups_count_by_dt(dt_type, dt, bookmark_id)
    connection.execute(<<~SQL)
      INSERT INTO bookmark_stats (
        bookmark_id,
        date_id,
        date_type,
        dups_count
      ) VALUES (
        #{bookmark_id},
        '#{dt}', 
        '#{dt_type}', 
        1
      ) ON CONFLICT ("date_id","date_type","bookmark_id") 
      DO UPDATE SET dups_count = bookmark_stats.dups_count + 1 RETURNING id
    SQL
  end

  def self.incr_likes_count_by_dt(dt_type, dt, bookmark_id)
    connection.execute(<<~SQL)
      INSERT INTO bookmark_stats (
        bookmark_id,
        date_id,
        date_type,
        dups_count
      ) VALUES (
        #{bookmark_id},
        '#{dt}', 
        '#{dt_type}', 
        1
      ) ON CONFLICT ("date_id","date_type","bookmark_id") 
      DO UPDATE SET likes_count = bookmark_stats.likes_count + 1 RETURNING id
    SQL
  end
end
