class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.datetime :start_date
      t.string :description
      t.float :amount
      t.string :comment

      t.timestamps
    end
  end
end
