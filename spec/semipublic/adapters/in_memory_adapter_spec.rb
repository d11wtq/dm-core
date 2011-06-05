require 'spec_helper'
require 'dm-core/spec/shared/adapter_spec'

describe 'Adapter' do
  supported_by :in_memory do
    describe 'DataMapper::Adapters::InMemoryAdapter' do

      it_should_behave_like 'An Adapter'

      describe 'reloading complex associations' do
        before :all do
          class ::Post
            include DataMapper::Resource

            property :id, Serial
            has n, :tags, :through => Resource
          end

          class Tag
            include DataMapper::Resource

            property :id, Serial
            has n, :posts, :through => Resource
          end
        end

        let(:post) do
          object = Post.new
          object.tags << Tag.new
          object.tags << Tag.new
          object.tags << Tag.new
          object.save
          object
        end

        it 'should be able to get all associations' do
          post.should have(3).tags
        end

        it 'should still be able to get all associations after #reload' do
          post.reload.should have(3).tags
        end
      end

    end
  end
end
