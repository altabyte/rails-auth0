# Non-authenticated public pages.
#
class PublicPagesController < ApplicationController
  layout 'public'

  def home; end
end
