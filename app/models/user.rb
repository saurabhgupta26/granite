class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze

  has_many :tasks, dependent: :destroy, foreign_key: :user_id
  has_secure_password

  validates :email, presence: true,
                    uniqueness: true,
                    length: { maximum: 50 },
                    format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true, on: :create
  before_save :to_lowercase


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

  def test_user_should_be_not_be_valid_and_saved_without_email
    @user.email = ''
    assert_not @user.valid?
  
    @user.save
    assert_equal ["Email can't be blank", 'Email is invalid'],
                  @user.errors.full_messages
  end
  
  def test_user_should_not_be_valid_and_saved_if_email_not_unique
    @user.save!
  
    test_user = @user.dup
    assert_not test_user.valid?
  
    assert_equal ['Email has already been taken'],
                  test_user.errors.full_messages
  end

  def test_reject_email_of_invalid_length
    @user.email = ('a' * 50) + '@test.com'
    assert @user.invalid?
  end

  def test_validation_should_accept_valid_addresses
    valid_emails = %w[user@example.com USER@example.COM US-ER@example.org
                      first.last@example.in user+one@example.ac.in]
  
    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?
    end
  end
  
  def test_validation_should_reject_invalid_addresses
    invalid_emails = %w[user@example,com user_at_example.org user.name@example.
                        @sam-sam.com sam@sam+exam.com fishy+#.com]
  
    invalid_emails.each do |email|
      @user.email = email
      assert @user.invalid?
    end
  end

  def test_user_should_not_be_saved_without_password
    @user.password = nil
    assert_not @user.save
    assert_equal ["Password can't be blank"],
                  @user.errors.full_messages
  end
  
  def test_user_should_not_be_saved_without_password_confirmation
    @user.password_confirmation = nil
    assert_not @user.save
    assert_equal ["Password confirmation can't be blank"],
                  @user.errors.full_messages
  end

  def test_users_should_have_unique_auth_token
    @user.save!
    second_user = User.create!(name: 'Olive Sans', email: 'olive@example.com',
                               password: 'welcome', password_confirmation: 'welcome')
  
    assert_not_same @user.authentication_token,
                    second_user.authentication_token
  end

  private

    def to_lowercase
      email.downcase!
    end
    
end