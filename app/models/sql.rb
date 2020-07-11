class SQL < ApplicationRecord

  private

  def self.exec(sql)
    connection.select_all sql
  end
end
