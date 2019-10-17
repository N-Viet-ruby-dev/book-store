require "rails_helper"

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.create(:guest_user)
  end

  describe "creation" do
    it "can be created" do
      expect(@user).to be_valid
    end

    it "can not be created without fullname" do
      @user.fullname = nil
      expect(@user).to_not be_valid
    end
  end

  describe "roles" do
    it "is guest or admin" do
      should define_enum_for(:role).with_values %i(guest admin)
    end
  end

  describe "custom method" do
    describe "reassign_room" do
      before do
        @admin = FactoryBot.create(:admin_user)
        @another_admin = FactoryBot.create(:admin_user)
        @room = FactoryBot.create(:room)
        @admin.online!
        @room.assign_to_admin
        @another_admin.online!
      end

      it "reassign rooms if admin offline after setting reassign time" do
        @admin.offline!
        @admin.updated_at = (Time.now - Settings.reassign_time_minute.minutes - 20.seconds)
        @admin.reassign_room
        expect(@room.assignee.id).to equal(@another_admin.id)
      end

      it "do not do anything if admin online" do
        @admin.reassign_room
        expect(@room.assignee.id).to equal(@admin.id)
      end

      it "do not do anything if updated at larger than now except setting time" do
        @admin.offline!
        @admin.updated_at = Time.now - Settings.reassign_time_minute.minutes + 10.seconds
        expect(@room.assignee.id).to equal(@admin.id)
      end
    end
  end
end
