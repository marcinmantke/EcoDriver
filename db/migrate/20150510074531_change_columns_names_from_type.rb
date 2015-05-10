class ChangeColumnsNamesFromType < ActiveRecord::Migration
  def change
    change_table :engine_types do |t|
      t.rename :type, :eng_type
    end
  end
end
