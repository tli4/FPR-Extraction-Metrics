require 'rails_helper'

RSpec.describe ApplicationController do
  controller do
    def index
      render 'evaluation/show'
    end

    def redirect_home_unless_return_to
      return_to_or_redirect_to root_path
    end
  end

  before do
    @routes.draw do
      get '/anonymous/index'
      get '/anonymous/redirect_home_unless_return_to'
    end
  end

  describe "#save_return_to" do
    it "saves the return to parameter in the session if present" do
      get :index, return_to: root_path
      expect(session[:return_to]).to eq(root_path)
    end
  end

  describe "#return_to_or_redirect_to" do
    it "redirects to the saved 'return to' location if it is set" do
      get :index, return_to: evaluation_index_path # set the return to
      get :redirect_home_unless_return_to
      expect(response).to redirect_to(evaluation_index_path)
    end

    it "redirects to the specified location if not 'return to' is saved" do
      get :redirect_home_unless_return_to
      expect(response).to redirect_to(root_path)
    end
  end
end
