class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def sanitize(string)
    Rails::Html::FullSanitizer.new.sanitize(string.to_s).gsub('&amp;', '&')
  end
end
