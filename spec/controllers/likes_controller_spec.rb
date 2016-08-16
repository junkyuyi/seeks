require 'rails_helper'

RSpec.describe LikesController, type: :controller do

  before do
    @user = create_user
    @secret1 = @user.secrets.create(content: "secret1")
    @secret2 = @user.secrets.create(content: "secret2")
    @like = Like.create(user: @user, secret: @secret1)
  end

  describe "when not logged in," do
    before do
      session[:user_id] = nil
    end
    it "cannot like a secret" do
      post :create
      expect(response).to redirect_to('/sessions/new')
    end
    it "cannot unlike a secret" do
      delete :destroy, id: @like.id
      expect(response).to redirect_to('/sessions/new')
    end
  end

  describe "when signed in as the wrong user" do
    before do
      @wrong_user = create_user 'julius', 'julius@lakers.com'
      session[:user_id] = @wrong_user.id
    end
    it "cannot unlike a secret on behalf of another user" do
      delete :destroy, id: @like.id
      expect(response).to redirect_to("/secrets")
      expect(Like.find(@like.id)).to_not be(nil)
    end

  end


end
