class CreateReportMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :report_mentions do |t|
      t.references :mention_to, foreign_key: { to_table: :reports }, null: false
      t.references :mentioned_by, foreign_key: { to_table: :reports }, null: false
      t.index %i[mention_to_id mentioned_by_id], unique: true
    end
  end
end
