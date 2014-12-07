class UrlKeyword < ActiveRecord::Base
  belongs_to :url_link
  belongs_to :keyword
end
