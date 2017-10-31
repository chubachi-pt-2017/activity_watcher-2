require 'rails_helper'

RSpec.describe ActivityWatcher::HomesController, type: :controller do
  let(:valid_attributes) {
    {
      name:    'name',
      source:  'https://github.com/terra-yucco/ruthenium',
      service: Faker::Internet.url('herokuapp.com')
    }
  }

  let(:invalid_attributes) {
    {
      name:    nil,
      source:  nil,
      service: nil
    }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all teams as @teams" do
      team = Team.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:teams)).to eq([team])
    end
  end
end
