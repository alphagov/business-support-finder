require 'ostruct'

class Type < OpenStruct
  HARDCODED_DATA = {
    "finance" => "Finance (any)",
    "equity" => "Equity",
    "grant" => "Grant",
    "loan" => "Loan (including guarantees)",
    "expertise-and-advice" => "Expertise and advice",
    "recognition-award" => "Recognition award",
  }.map do |slug, name|
    new(:slug => slug, :name => name)
  end

  def self.all
    HARDCODED_DATA
  end
end
