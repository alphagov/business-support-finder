require "validate_array_inclusion"

class BusinessSupport
  include Mongoid::Document
  include ValidateArrayInclusion

  field :title, type: String
  field :description, type: String

  # Facets
  field :business_stages, type: Array, default: []
  field :business_types, type: Array, default: []
  field :purposes, type: Array, default: []
  field :support_types, type: Array, default: []
  field :business_sectors, type: Array, default: []

  field :website_url, type: String
  field :contact_details, type: String
  field :organiser, type: String

  field :min_turnover, type: Integer
  field :max_turnover, type: Integer
  field :min_grant_value, type: Integer
  field :max_grant_value, type: Integer
  field :min_age, type: Integer
  field :max_age, type: Integer
  field :min_employees, type: Integer
  field :max_employees, type: Integer



  #field :region, type: Array

  BUSINESS_STAGES = ["Pre-startup", "Start-up", "Grow and sustain", "Exiting a business"]
  BUSINESS_TYPES  = ["Private company", "Partnership", "Public limited company", "Social enterprise", "Sole trader", "Charity"]
  PURPOSES = ["Business growth and expansion", "Consultancy and business advice", "Finding new customers and markets",
      "Developing new product or service ideas", "Easing administration", "Energy efficiency and the environment",
      "Exchanging ideas and sharing expertise", "Exporting or finding overseas partners",
      "Investing in community development", "Learning from other businesses", "Taking on staff and developing people",
      "Investing in plant, machinery or property", "Making the most of the internet", "Setting up your business",
      "Performance improvement and best practice", "Setting up or running a rural business", "Conservation",
      "Specific support for women in business", "Taking new products or services to market", "Marketing"
  ]
  SUPPORT_TYPES = ["Award", "Consultancy", "Equity", "Expertise and advice", "Finance", "Grant", "Loan", "Recognition award"]
  BUSINESS_SECTORS = ["Agriculture", "Business and finance", "Construction", "Education", "Health", "Real estate",
      "Hospitality and catering", "Information, communication and media", "Manufacturing", "Mining", "Wholesale and retail",
      "Science and technology", "Service industries", "Transport and distribution", "Travel and leisure", "Utilities"
  ]

  validates :title, presence: true
  validates_uniqueness_of :title
  validates :description, presence: true

  validates_array_inclusion :business_stages, BUSINESS_STAGES
  validates_array_inclusion :business_types, BUSINESS_TYPES
  validates_array_inclusion :purposes, PURPOSES
  validates_array_inclusion :support_types, SUPPORT_TYPES
  validates_array_inclusion :business_sectors, BUSINESS_SECTORS

  validate :min_less_than_max

  private
  def min_less_than_max
    test_min_max(:turnover)
    test_min_max(:grant_value)
    test_min_max(:age)
    test_min_max(:employees)
  end
  def test_min_max(name)
    min = send("min_#{name}".to_sym)
    max = send("max_#{name}".to_sym)
    pretty_name = name.to_s.sub(/_/, ' ')
    if min.present? and max.present? and min > max
      errors["min_#{name}".to_sym] << "Min #{pretty_name} must be smaller than #{pretty_name}"
      errors["max_#{name}".to_sym] << "Max #{pretty_name} must be larger than #{pretty_name}"
    end
  end
end
