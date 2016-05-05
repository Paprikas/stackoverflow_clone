require 'rails_helper'

describe Votable do
  with_model :WithVotable do
    table do |t|
      t.references :user
    end

    model do
      include Votable
      belongs_to :user
    end
  end

  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:votable) { WithVotable.create }

  describe 'votes up' do
    it 'votes up' do
      expect {
        votable.vote(user, 1)
      }.to change(votable.votes, :count).by(1)
      expect(votable.vote_score).to eq 1
    end

    it 'cancels vote' do
      votable.vote(user, 1)
      expect {
        votable.cancel_vote(user)
      }.to change(votable.votes, :count).by(-1)
      expect(votable.vote_score).to eq 0
    end
  end

  describe 'votes down' do
    it 'votes down votable' do
      expect {
        votable.vote(user, -1)
      }.to change(votable.votes, :count).by(1)
      expect(votable.vote_score).to eq(-1)
    end

    it 'cancels vote' do
      votable.vote(user, -1)
      expect {
        votable.cancel_vote(user)
      }.to change(votable.votes, :count).by(-1)
      expect(votable.vote_score).to eq 0
    end
  end

  describe 'replace' do
    xit 'replaces vote' do
      votable.vote(user, 1)
      votable.vote(user, -1)
      expect(votable.vote_score).to eq(-1)
    end
  end

  describe 'vote score' do
    it 'checks score calculation, 2 positive' do
      votable.vote(user, 1)
      votable.vote(user2, 1)
      expect(votable.vote_score).to eq 2
    end

    it 'checks score calculation, 2 negative' do
      votable.vote(user, -1)
      votable.vote(user2, -1)
      expect(votable.vote_score).to eq(-2)
    end

    it 'checks score calculation, 1 negative, 1 positive' do
      votable.vote(user, 1)
      votable.vote(user2, -1)
      expect(votable.vote_score).to eq 0
    end
  end
end
