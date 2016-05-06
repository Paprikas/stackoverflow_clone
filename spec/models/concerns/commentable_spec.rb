require 'rails_helper'

describe Commentable do
  with_model :WithCommentable do
    model do
      include Commentable
    end
  end

  let(:commentable) { WithCommentable.create }
  let(:comment) { build(:comment, commentable: commentable) }
  let(:invalid_comment) { build(:comment, :invalid, commentable: commentable) }

  it 'valid comment' do
    comment.valid?
    expect(comment).to be_valid
  end

  it 'invalid comment' do
    invalid_comment.valid?
    expect(invalid_comment).not_to be_valid
  end

  it 'creates comment' do
    expect { comment.save }.to change(commentable.comments, :count).by(1)
  end

  it 'creates invalid comment' do
    expect { invalid_comment.save }.not_to change(commentable.comments, :count)
  end
end
