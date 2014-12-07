class UrlContext < ActiveRecord::Base
  belongs_to :keyword_context
  belongs_to :url_link
end
