require 'spec_helper'

describe Scheme do

  describe "looking up schemes" do
    before :each do
      @sector = 'health'
      @stage = 'start-up'
      @size = 'under-10'
      @support_types = %w(finance loan)
      @location = 'wales'
      GdsApi::Imminence.any_instance.stub(:business_support_schemes).and_return("results" => [])
      GdsApi::ContentApi.any_instance.stub(:business_support_schemes).and_return("results" => [])
    end

    after :each do
      # Necessary to prevent stack level too deep errors caused by objects with stubs
      # applied being persisted between requests.
      Scheme.instance_variable_set('@content_api', nil)
      Scheme.instance_variable_set('@imminence_api', nil)
    end

    it "should lookup available schemes in imminence" do
      GdsApi::Imminence.any_instance.should_receive(:business_support_schemes).
        with(
          :sectors => "health",
          :stages => "start-up",
          :business_sizes => "under-10",
          :support_types => "finance,loan",
          :locations => "wales").
        and_return("results" => [])

      Scheme.lookup(:sector => @sector, :stage => @stage, :size => @size, :support_types => @support_types, :location => @location)
    end

    it "should fetch the imminence schemes from content_api" do
      GdsApi::Imminence.any_instance.stub(:business_support_schemes).
        and_return("results" => [
                          {"business_support_identifier" => "scheme-1"},
                          {"business_support_identifier" => "scheme-3"},
                          {"business_support_identifier" => "scheme-2"},
                        ])
      GdsApi::ContentApi.any_instance.should_receive(:business_support_schemes).with(%w(scheme-1 scheme-3 scheme-2)).
        and_return("results" => [])

      Scheme.lookup(:sectors => @sector, :stage => @stage, :size => @size, :support_types => @support_types, :location => @location)
    end

    it "should construct instances of Scheme for each result and return them" do
      GdsApi::Imminence.any_instance.stub(:business_support_schemes).
        and_return("results" => [{"business_support_identifier" => "scheme-1"}])
      GdsApi::ContentApi.any_instance.stub(:business_support_schemes).
        and_return("results" => [:artefact1, :artefact2])
      Scheme.should_receive(:new).with(:artefact1).and_return(:scheme1)
      Scheme.should_receive(:new).with(:artefact2).and_return(:scheme2)

      schemes = Scheme.lookup(:sectors => @sector, :stage => @stage, :size=> @size, :support_types => @support_types, :location => @location)
      schemes.should == [:scheme1, :scheme2]
    end

    it "should order the schemes by the imminence api result order" do

      artefact1 = {"identifier" => "1", "title" => "artefact1"}
      artefact2 = {"identifier" => "2", "title" => "artefact2"}
      artefact3 = {"identifier" => "3", "title" => "artefact3"}
      artefact4 = {"identifier" => "4", "title" => "artefact4"}

      GdsApi::Imminence.any_instance.stub(:business_support_schemes).
        and_return("results" => [
                   {"business_support_identifier" => "4"},
                   {"business_support_identifier" => "1"},
                   {"business_support_identifier" => "3"},
                   {"business_support_identifier" => "2"}])

      GdsApi::ContentApi.any_instance.stub(:business_support_schemes).
        and_return("results" => [artefact1, artefact2, artefact3, artefact4])

      Scheme.should_receive(:new).with(artefact1).and_return(:scheme1)
      Scheme.should_receive(:new).with(artefact2).and_return(:scheme2)
      Scheme.should_receive(:new).with(artefact3).and_return(:scheme3)
      Scheme.should_receive(:new).with(artefact4).and_return(:scheme4)

      schemes = Scheme.lookup(:sectors => @sector, :stage => @stage, :size => @size, :support_types => @support_types, :location => @location)
      schemes.should == [:scheme4, :scheme1, :scheme3, :scheme2]
    end

    it "should return empty array without calling content_api if imminence returns no results" do
      GdsApi::Imminence.any_instance.stub(:business_support_schemes).and_return("results" => [])
      GdsApi::ContentApi.any_instance.should_not_receive(:business_support_schemes)

      schemes = Scheme.lookup(:sectors => @sector, :stage => @stage, :size => @size, :support_types => @support_types, :location => @location)
      schemes.should == []
    end
  end

  describe "constructing from content_api artefact hash" do
    it "should assign all top-level fields to the openstruct" do
      s = Scheme.new("foo" => "bar", "something_else" => "wibble")

      s.foo.should == "bar"
      s.something_else.should == "wibble"
    end

    it "should assign all details fields to the openstruct" do
      s = Scheme.new("details" => {"foo" => "bar", "something_else" => "wibble"})

      s.foo.should == "bar"
      s.something_else.should == "wibble"
    end

    it "should not let details fields overwrite top-level fields" do
      s = Scheme.new("format" => "top level format", "details" => {"format" => "details format"})

      s.format.should == "top level format"
    end

    it "should not add a details member to the openstruct" do
      s = Scheme.new("details" => {"foo" => "bar", "something_else" => "wibble"})

      s.details.should == nil
    end
  end
end
