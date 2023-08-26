class UserRssShip < ApplicationRecord
  belongs_to :user
  belongs_to :probe_setting

  validates :user_id, presence: true
  # validates :probe_setting_id, presence: true

  after_destroy :destroy_probe_setting

  def destroy_probe_setting
    ProbeSetting.destroy(self.probe_setting_id) if ProbeSetting
                                                     .find_by(id: self.probe_setting_id)
                                                     .users
                                                     .empty?
  end
end
