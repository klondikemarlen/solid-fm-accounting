class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :first_name, null: false
      t.string :last_name
      t.string :display_name, null: false
      t.string :auth0_subject, null: false

      t.timestamps
      t.datetime :deleted_at, precision: 6

      t.index(
        :email,
        name: "index_users_on_email_unique",
        unique: true,
        where: "deleted_at IS NULL"
      )
      t.index(
        :auth0_subject,
        name: "index_users_on_auth0_subject_unique",
        unique: true,
        where: "deleted_at IS NULL"
      )
    end
  end
end
