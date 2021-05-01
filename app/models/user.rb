class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 35 }
  has_many :tasks, dependent: :destroy

  def test_user_should_be_not_be_valid_without_name
    @user.name = ''
    assert_not @user.valid?
    assert_equal ["Name can't be blank"], @user.errors.full_messages
  end

  def test_name_should_be_of_valid_length
    @user.name = 'a' * 50
    assert @user.invalid?
  end
  
  def test_instance_of_user
    assert_instance_of User, @user
  end
  
  def test_not_instance_of_user
    task = Task.new
    assert_not_instance_of User, task
  end
    
end