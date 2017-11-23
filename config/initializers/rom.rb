ROM::Rails::Railtie.configure do |config|
  config.gateways[:default] = [
    :sql, "sqlite:////home/marcin/Projects/Rails/cqrs_exploration/db/#{Rails.env}.sqlite3", not_inferrable_relations: [:schema_migrations]
  ]
end
