class UsersReadModel
  class << self

    #write
    def add_user(uid, user)
      name = user.name
      email = user.email

      sql = <<-SQL
        insert into users (uid, name, email, created_at, updated_at)
        values ('#{ uid }', '#{ name }', '#{ email }', '#{ Time.now }', '#{ Time.now }')
      SQL

      ActiveRecord::Base.connection.execute(sql)
    end

    #read
    def all_users
      sql = <<-SQL
        select * from users
      SQL

      ActiveRecord::Base.connection.execute(sql)
    end

    #validate
    def available_email?(email)
      sql = <<-SQL
        select * from users
        where email = '#{email}'
      SQL

      emails = ActiveRecord::Base.connection.execute(sql)
      emails.empty?
    end

  end
end
