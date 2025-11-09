# == Schema Information
#
# Table name: users
#
#  id            :bigint           not null, primary key
#  auth0_subject :string           not null
#  deleted_at    :datetime
#  display_name  :string           not null
#  email         :string           not null
#  first_name    :string           not null
#  last_name     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_users_on_auth0_subject_unique  (auth0_subject) UNIQUE WHERE (deleted_at IS NULL)
#  index_users_on_email_unique          (email) UNIQUE WHERE (deleted_at IS NULL)
#
class User < ApplicationRecord
end
