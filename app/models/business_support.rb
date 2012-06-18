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
  #field :region, type: Array

  BUSINESS_STAGES = ["Pre-startup", "Startup", "Grow and sustain", "Exiting a business"]
  BUSINESS_TYPES  = ["Private Company", "Partnership", "Public limited company", "Social enterprise", "Sole trader", "Charity"]
  PURPOSES = ["Business growth and expansion", "Consultancy and business advice", "Finding new customers and markets",
      "Developing new product or service ideas", "Easing administration", "Energy efficiency and the environment",
      "Exchanging ideas and sharing expertise", "Exporting or finding overseas partners",
      "Investing in community development", "Learning from other businesses", "Taking on staff and developing people",
      "Investing in plant, machinery or property", "Making the most of the Internet", "Setting up your business",
      "Performance improvement and best practice", "Setting up or running a rural business", "Conservation",
      "Specific support for women in business", "Taking new products or services to market", "Marketing"
  ]
  SUPPORT_TYPES = ["Award", "Consultancy", "Equity", "Expertise and advice", "Finance", "Grant", "Loan", "Recognition award"]
  BUSINESS_SECTORS = ["Agriculture", "Business and Finance", "Construction", "Education", "Health", "Real Estate",
      "Hospitality and Catering", "Information, Communication and Media", "Manufacturing", "Mining", "Wholesale and Retail",
      "Science and Technology", "Service Industries", "Transport and Distribution", "Travel and Leisure", "Utilities"
  ]

  validates :title, presence: true
  validates :description, presence: true

  validates_array_inclusion :business_stages, BUSINESS_STAGES
  validates_array_inclusion :business_types, BUSINESS_TYPES
  validates_array_inclusion :purposes, PURPOSES
  validates_array_inclusion :support_types, SUPPORT_TYPES
  validates_array_inclusion :business_sectors, BUSINESS_SECTORS
end
