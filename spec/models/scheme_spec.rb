require 'spec_helper'

describe Scheme do
  describe "lookup" do
    it "should lookup schemes via the business support api" do
      Scheme.business_support_api.should_receive(:schemes)
        .with({:foo => "bar"}).and_return([:scheme1, :scheme2])
      Scheme.lookup({:foo => "bar"}).should == [:scheme1, :scheme2]

      Scheme.business_support_api.should_receive(:schemes)
        .with({}).and_return([:scheme1])
      Scheme.lookup({}).should == [:scheme1]
    end
  end
end
