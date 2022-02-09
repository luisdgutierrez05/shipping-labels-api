# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Adapters::MultiCarrierAdapter do
  describe 'delegation' do

    subject { described_class.new(OpenStruct.new(request: 'request method from adapter')) }
    it 'delegates the method to adapter' do
      expect(subject.request).to eq('request method from adapter')
    end
  end
end
