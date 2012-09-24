require 'spec_helper'

describe AddRemoveHelper do
  def as_nokogiri(html_string)
    Nokogiri::HTML.fragment(html_string.strip)
  end

  describe "link_to_add_remove" do
    before :each do
      @sector1 = Sector.new(:name => "Alpha", :slug => "alpha")
      @sector2 = Sector.new(:name => "Bravo", :slug => "bravo")
      @sector3 = Sector.new(:name => "Charlie", :slug => "charlie")
      params[:controller] = "business_support"
    end

    describe "add link" do
      it "should create a link to add the sector" do
        result = helper.link_to_add_remove(:add, @sector2)
        doc = as_nokogiri(result)

        doc.should have_xpath("//li[@id='sector-bravo'][@data-slug='bravo']")
        doc.should have_xpath("//li[@id='sector-bravo']/span[text() = 'Bravo']")
        doc.should have_xpath("//li[@id='sector-bravo']/a[@href='/#{APP_SLUG}/sectors?sectors=bravo'][text() = 'Add']")
      end

      it "should preserve given selected sectors in the add link" do
        result = helper.link_to_add_remove(:add, @sector2, :existing_items => [@sector1])
        doc = as_nokogiri(result)

        link = doc.at_xpath("li[@id='sector-bravo']/a")
        link["href"].should == "/#{APP_SLUG}/sectors?sectors=alpha_bravo"
      end

      it "should sort sector slugs in link alphabetically" do
        result = helper.link_to_add_remove(:add, @sector2, :existing_items => [@sector1, @sector3])
        doc = as_nokogiri(result)

        link = doc.at_xpath("li[@id='sector-bravo']/a")
        link["href"].should == "/#{APP_SLUG}/sectors?sectors=alpha_bravo_charlie"
      end

      it "should not include duplicate items" do
        result = helper.link_to_add_remove(:add, @sector2, :existing_items => [@sector2, @sector3])
        doc = as_nokogiri(result)

        link = doc.at_xpath("li[@id='sector-bravo']/a")
        link["href"].should == "/#{APP_SLUG}/sectors?sectors=bravo_charlie"
      end

      it "should not have side effects on the passed in array" do
        existing = [@sector1]
        helper.link_to_add_remove(:add, @sector2, :existing_items => existing)

        existing.should == [@sector1]
      end
    end

    describe "remove link" do
      it "should create a link to remove the sector" do
        result = helper.link_to_add_remove(:remove, @sector2, :existing_items => [@sector1, @sector2])
        doc = as_nokogiri(result)

        doc.should have_xpath("//li[@id='sector-bravo'][@data-slug='bravo']")
        doc.should have_xpath("//li[@id='sector-bravo']/span[text() = 'Bravo']")
        doc.should have_xpath("//li[@id='sector-bravo']/a[@href='/#{APP_SLUG}/sectors?sectors=alpha'][text() = 'Remove']")
      end

      it "should handle removing the last sector" do
        result = helper.link_to_add_remove(:remove, @sector2, :existing_items => [@sector2])
        doc = as_nokogiri(result)

        link = doc.at_xpath("li[@id='sector-bravo']/a")
        link["href"].should == "/#{APP_SLUG}/sectors?sectors="
      end

      it "should do 'the right thing' if the given sector is not an existing one" do
        result = helper.link_to_add_remove(:remove, @sector2, :existing_items => [@sector1, @sector3])
        doc = as_nokogiri(result)

        link = doc.at_xpath("li[@id='sector-bravo']/a")
        link["href"].should == "/#{APP_SLUG}/sectors?sectors=alpha_charlie"
      end

      it "should not have side effects on the passed in array" do
        existing = [@sector1, @sector2]
        helper.link_to_add_remove(:remove, @sector2, :existing_items => existing)

        existing.should == [@sector1, @sector2]
      end
    end
  end

  it "link_to_add should call link_to_add_remove" do
    helper.should_receive(:link_to_add_remove).with(:add, :model, :options)
    helper.link_to_add(:model, :options)
  end

  it "link_to_remove should call link_to_add_remove" do
    helper.should_receive(:link_to_add_remove).with(:remove, :model, :options)
    helper.link_to_remove(:model, :options)
  end
end
