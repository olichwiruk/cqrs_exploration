# frozen_string_literal: true

class UsersReadModel
  class << self
    # write
    def add_user(uid, user)
      name = user.name
      email = user.email

      sql = <<-SQL
        insert into users (uid, name, email, created_at, updated_at)
        values ('#{uid}', '#{name}', '#{email}', '#{Time.now}', '#{Time.now}')
      SQL

      ActiveRecord::Base.connection.execute(sql)
    end

    # read
    def all_users
      sql = <<-SQL
        select * from users
      SQL

      ActiveRecord::Base.connection.execute(sql)
    end

    def find(id)
      sql = <<-SQL
        select * from users
        where id = '#{id}'
      SQL

      user_hash = ActiveRecord::Base.connection.execute(sql).first
        .select { |k, _| k.is_a? String }

      ReadModel::User.new(
        ::User.new(user_hash)
      )
    end

    # validate
    def available_email?(email)
      sql = <<-SQL
        select 1 from users
        where email = '#{email}'
      SQL

      emails = ActiveRecord::Base.connection.execute(sql)
      emails.empty?
    end

    def available_email_for_user?(user_id, email)
      sql = <<-SQL
        select 1 from users
        where email = '#{email}'
        and id != '#{user_id}'
      SQL

      emails = ActiveRecord::Base.connection.execute(sql)
      emails.empty?
    end
  end
end
