# frozen_string_literal: true

class Header < SitePrism::Section
  element :logo, 'img.logo'
  element :input_login, 'input.login'

  section :comments_holder, '.comments-holder' do
    sections :comment, '.comment' do
      element :content, '.comment__content'

      section :author, '.author' do
        element :name, '.author__name'
        element :avatar, '.author__avatar img'
      end
    end

    element :new_button, 'button.new-comment'
  end

  def post_date
    date_time.text.split.first
  end
end
