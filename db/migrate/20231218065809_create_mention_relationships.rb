class CreateMentionRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :mention_relationships do |t|
      t.references :report, foreign_key: true
      t.references :mention, foreign_key: { to_table: :reports}
      t.index %i[report_id mention_id], unique: true
    end
  end
end
