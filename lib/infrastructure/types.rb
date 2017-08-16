module Types
  include Dry::Types.module

  Email = String.constrained(format:
                /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
end
