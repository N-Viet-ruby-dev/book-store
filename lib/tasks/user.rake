namespace :user do
  desc "TODO"
  task destroy_guest_user: :environment do
    User.guest.where( "updated_at >=  :one_month_ago", one_month_ago: (Time.now - 1.month) ).destroy_all
  end
end
