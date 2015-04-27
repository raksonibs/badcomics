class AddSubscribedAndFirstEmailSentToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :subscribed, :boolean, :default => true
    add_column :subscribers, :intro_sent, :boolean, :default => true
  end
end
