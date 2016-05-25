require 'spec_helper'

describe "Load samples" do
  it "loads data successfully" do
    expect {
      # Seeds are only run for rake test_app so to allow this spec to pass without
      # rerunning rake test_app every time we must load them in if not already.
      unless Spree::Zone.find_by_name("North America")
        load Rails.root + 'Rakefile'
        load Rails.root + 'db/seeds.rb'
      end

      SpreeSample::Engine.load_samples
    }.to output.to_stdout

    # loading sample data is slow, so we want run all expectations together
    aggregate_failures("sample data") do
      expect(Spree::Store.count).to eq(1)
      expect(Spree::Store.first).to eq(be_default)
    end
  end
end
