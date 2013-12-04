class CreateCampaignsPlatforms < ActiveRecord::Migration
  def change
    create_table :campaigns_platforms do |t|
      t.integer :campaign_id
      t.integer :platform_id

      t.timestamps
    end
  end
end
