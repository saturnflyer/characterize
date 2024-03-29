class UsersController < ApplicationController
  Characterize.standard_features = Characterize.builtin_standard_features + [StandardCharacter]

  characterize :user,
    default: [SpecialCharacter, UserCharacter],
    edit: [EditUserCharacter]

  characterize :widget, default: [SpecialCharacter, WidgetCharacter] do
    def load_widget
      Widget.new
    end
  end

  characterize_each :users,
    index: [UserCollectionCharacter] do
      def load_users
        User.unscoped
      end
    end

  def index
  end

  def show
  end

  def edit
    render plain: user.editing_title
  end
end
