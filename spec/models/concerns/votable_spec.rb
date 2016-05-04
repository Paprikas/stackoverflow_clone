require 'rails_helper'

describe 'votable' do
  with_model :WithVotable do
    model do
      include Votable
    end
  end

  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:votable) { WithVotable.create }

  describe 'votes up' do
    it 'votes up' do
      expect {
        votable.toggle_vote_up!(user)
      }.to change(votable.votes, :count).by(1)
      expect(votable.vote_score).to eq 1
    end

    it 'removes vote' do
      votable.toggle_vote_up!(user)
      expect {
        votable.toggle_vote_up!(user)
      }.to change(votable.votes, :count).by(-1)
      expect(votable.vote_score).to eq 0
    end
  end

  describe 'votes down' do
    it 'votes down votable' do
      expect {
        votable.toggle_vote_down!(user)
      }.to change(votable.votes, :count).by(1)
      expect(votable.vote_score).to eq(-1)
    end

    it 'removes vote' do
      votable.toggle_vote_down!(user)
      expect {
        votable.toggle_vote_down!(user)
      }.to change(votable.votes, :count).by(-1)
      expect(votable.vote_score).to eq 0
    end
  end

  describe 'vote score' do
    it 'checks score calculation, 2 positive' do
      votable.toggle_vote_up!(user)
      votable.toggle_vote_up!(user2)
      expect(votable.vote_score).to eq 2
    end

    it 'checks score calculation, 2 negative' do
      votable.toggle_vote_down!(user)
      votable.toggle_vote_down!(user2)
      expect(votable.vote_score).to eq(-2)
    end

    it 'checks score calculation, 1 negative, 1 positive' do
      votable.toggle_vote_up!(user)
      votable.toggle_vote_down!(user2)
      expect(votable.vote_score).to eq 0
    end
  end
end
