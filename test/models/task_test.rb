require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: 'Sam Smith', email: 'sam@example.com', password: 'welcome', password_confirmation: 'welcome')
    Task.delete_all

    @task = Task.new(title: 'This is a test task', user: @user)
  end
  
  def test_instance_of_task
    task = Task.new
  
    # See if object task actually belongs to Task
    assert_instance_of Task, task
  end

  def test_not_instance_of_user
    task = Task.new
    assert_not_instance_of User, task
  end

  def test_value_of_title_assigned
    task = Task.new(title: "Title assigned for testing")

    # assert task.title == "Title assigned for testing"
    assert_equal "Title assigned for testing", task.title
  end

  def test_value_created_at
    assert_nil @task.created_at
  
    @task.save!
    assert_not_nil @task.created_at
  end

  def test_error_raised
    assert_raises ActiveRecord::RecordNotFound do
      Task.find(SecureRandom.uuid)
    end
  end

  def test_count_of_number_of_tasks
    assert_difference ['Task.count'], 2 do
      Task.create!(title: 'Creating a task through test', user: @user)
      Task.create!(title: 'Creating another task through test', user: @user)
    end
  end

  def test_task_should_not_be_valid_without_title
    @task.title = ''
    assert @task.invalid?
  end

  def test_task_slug_is_parameterized_title
    title = @task.title
    @task.save!
    assert_equal title.parameterize, @task.slug
  end

  def test_incremental_slug_generation_for_tasks_with_same_title
    first_task = Task.create!(title: 'test task', user: @user)
    second_task = Task.create!(title: 'test task', user: @user)
  
    assert_equal 'test-task', first_task.slug
    assert_equal 'test-task-2', second_task.slug
  end

  def test_error_raised_for_duplicate_slug
    test_task = Task.create!(title: 'test task', user: @user)
    another_test_task = Task.create!(title: 'anoter test task', user: @user)
  
    test_task_tile = test_task.title
    assert_raises ActiveRecord::RecordInvalid do
      another_test_task.update!(slug: test_task_tile.parameterize)
    end
  
    assert_match t('task.slug.immutable'), another_test_task.errors.full_messages.to_sentence
  end

  def test_updating_title_does_not_update_slug
    @task.save!
    task_slug = @task.slug
  
    updated_task_title = 'updated task tile'
    @task.update!(title: updated_task_title)
  
    assert_equal updated_task_title, @task.title
  
    assert_equal task_slug, @task.slug
  end

  def test_slug_to_be_reused_after_getting_deleted
    first_task = Task.create!(title: 'test task', user: @user)
    second_task = Task.create!(title: 'test task', user: @user)
  
    second_task_slug = second_task.slug
    second_task.destroy
    new_task_with_same_title = Task.create!(title: 'test task', user: @user)
  
    assert_equal second_task_slug, new_task_with_same_title.slug
  end
  
  ###################################################################################

  def test_user_should_be_not_be_valid_and_saved_without_email
    @user.email = ''
    assert_not @user.valid?
  
    @user.save
    assert_equal ["Email can't be blank", 'Email is invalid'], @user.errors.full_messages
  end

  def test_user_should_not_be_valid_and_saved_if_email_not_unique
    @user.save!
  
    test_user = @user.dup
    assert_not test_user.valid?
  
    assert_equal ['Email has already been taken'], test_user.errors.full_messages
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
    assert_equal ["Password can't be blank"], @user.errors.full_messages
  end
  
  def test_user_should_not_be_saved_without_password_confirmation
    @user.password_confirmation = nil
    assert_not @user.save
    assert_equal ["Password confirmation can't be blank"], @user.errors.full_messages
  end

  def test_users_should_have_unique_auth_token
    @user.save!
    second_user = User.create!(name: 'Olive Sans', email: 'olive@example.com', password: 'welcome', password_confirmation: 'welcome')
  
    assert_not_same @user.authentication_token, second_user.authentication_token
  end

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