class CreateRaffles < ActiveRecord::Migration[5.2]
  def change
    create_table :raffles do |t|
      t.references :pr_owner, foreign_key: { to_table: 'users' }
      t.references :first_raffle, foreign_key: { to_table: 'users' }
      t.references :second_raffle, foreign_key: { to_table: 'users' }

      t.timestamps
    end
  end
end
