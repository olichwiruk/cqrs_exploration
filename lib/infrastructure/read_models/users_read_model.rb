class UsersReadModel

  class << self

    def add_user(uid, user)
      name = user.name
      email = user.email

      sql = <<-SQL
        insert into users (uid, name, email, created_at, updated_at)
        values ('#{ uid }', '#{ name }', '#{ email }', '#{ Time.now }', '#{ Time.now }')
      SQL

      ActiveRecord::Base.connection.execute(sql)
    end

    def all_users
      sql = <<-SQL
        select * from users
      SQL

      ActiveRecord::Base.connection.execute(sql)
    end
  end

end
