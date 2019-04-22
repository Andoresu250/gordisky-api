User.create!(email: "admin@admin.com", password: "12345678", password_confirmation: "12345678") { |u| u.profile = Admin.create!(name: "Admin") }
User.create!(email: "empresa@empresa.com", password: "12345678", password_confirmation: "12345678") { |u| u.profile = Company.create!(name: "Test") }
User.create!(email: "empresa2@empresa.com", password: "12345678", password_confirmation: "12345678") { |u| u.profile = Company.create!(name: "Kelly") }
User.create!(email: "empresa3@empresa.com", password: "12345678", password_confirmation: "12345678") { |u| u.profile = Company.create!(name: "Jorge") }
Person.create!(first_names: "Andres Felipe", last_names: "Vera Arenas", identification: "1140876239", phone: "3012785751", address: "Calle 65 # 41 - 41")