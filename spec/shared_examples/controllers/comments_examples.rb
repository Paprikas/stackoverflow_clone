shared_examples 'create controller comments' do
  let(:post_comment) { post :comment, xhr: true, params: { id: commentable, comment: attributes_for(:comment) } }
  let(:invalid_comment) { post :comment, xhr: true, params: { id: commentable, comment: attributes_for(:comment, :invalid) } }

  context 'as user' do
    before { sign_in user }
    describe "POST #create" do
      it "returns http success and assigns @comment, @commentable", :aggregate_failures do
        post_comment
        expect(response).to have_http_status :success
        expect(assigns(:comment)).to eq commentable.comments.first
        expect(assigns(:commentable)).to eq commentable
      end

      it 'creates comment' do
        expect { post_comment }.to change(commentable.comments, :count).by(1)
      end

      it "doesn't creates invalid comment" do
        expect { invalid_comment }.not_to change(commentable.comments, :count)
      end
    end
  end

  context 'as guest' do
    describe "POST #create" do
      it "returns http unauthorized" do
        post_comment
        expect(response).to have_http_status :unauthorized
      end

      it "doesn't creates comment" do
        expect { post_comment }.not_to change(commentable.comments, :count)
      end
    end
  end
end
