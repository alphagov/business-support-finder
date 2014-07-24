require 'gds_api/test_helpers/imminence'

module ImminenceApiHelper

  include GdsApi::TestHelpers::Imminence

  def stub_imminence_areas_request(areas)
    stub_request(:get, %r{\A#{Plek.current.find('imminence')}/areas/EUR.json}).to_return(
      body: areas_response(areas)
    )
  end

  private

  def areas_response(areas)
    {
      "_response_info" => { "status" => "ok","links" => [] },
      "total" => areas.size,
      "start_index" => 1,
      "page_size" => areas.size,
      "current_page" => 1,
      "pages" => 1,
      "results" => areas
    }.to_json
  end
end
