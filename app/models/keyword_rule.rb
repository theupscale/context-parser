class KeywordRule < ActiveRecord::Base
  belongs_to :keyword_context
  belongs_to :keyword
end
