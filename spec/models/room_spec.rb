require "rails_helper"

RSpec.describe Room, type: :model do
  before do
    @room = FactoryBot.create(:room)
  end

  describe Room do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "Validation" do
    it "can not be created without name" do
      @room.name = nil
      expect(@room).to_not be_valid
    end

    it "can not be created with the same name" do
      @room1 = FactoryBot.create(:room)
      @room1.name = @room.name
      expect(@room1).to_not be_valid
    end

    it "can be created without the assignee association" do
      @room.assignee_id = nil
      expect(@room).to be_valid
    end

    it "can not be created without the guest association" do
      @room.guest_id = nil
      expect(@room).to_not be_valid
    end
  end

  describe "status" do
    it "is opening or closed" do
      should define_enum_for(:status).with_values %i(opening closed)
    end
  end

  describe "Custom method" do
    describe "assign_to_admin" do
      before do
        @admin = FactoryBot.create(:admin_user)
        @another_admin = FactoryBot.create(:admin_user)
      end

      it "assigns to online admin first" do
        @admin.online!
        @room.assign_to_admin
        expect(@room.assignee.id).to equal(@admin.id)
      end

      it "assigns to admin who has minimum opening room" do
        @another_room = FactoryBot.create(:room)
        @admin.online!
        @room.assign_to_admin
        @another_admin.online!
        @another_room.assign_to_admin
        expect(@another_room.assignee.id).to equal(@another_admin.id)
      end
    end
  end
end
