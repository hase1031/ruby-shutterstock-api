require 'spec_helper'

describe Image do
  before do
    client
  end

  let(:id) { 118_139_110 }
  subject(:image) { Image.find(id: id)  }

  it 'Should return an Image object' do
    expect(Image).to respond_to(:find)
    expect(image).to_not be_nil

    expect(image.id).to eql id
  end

  it 'should return similar images' do
    result = Image.find_similar(id)
    expect(result).to_not be_nil
    expect(result).to be_kind_of Array
    expect(result).to be_kind_of Images
    expect(result[0]).to be_kind_of Image
    expect(result.raw_data).to be_kind_of Hash
    expect(result.page).to be 1
    expect(result.total_count).to be >= 200
    expect(result.search_id).to_not be_nil
  end

  it 'should find similar images, given an image' do
    expect(image.find_similar).to be_kind_of Images
  end

  it 'should be able to search for images based on query' do
    results = Image.search('purple cat')
    expect(results).to be_kind_of Images
    expect(results.size).to be >= 20
  end
end
