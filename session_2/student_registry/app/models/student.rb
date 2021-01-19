class Student < ApplicationRecord
    validates :cgpa, numericality:{less_than_or_equal_to: 10.0, greater_than_or_equal_to: 0.00}
end
