require_relative 'font_awesome_helper'
require_relative 'redcarpet_helper'

module ApplicationHelper

  include FontAwesomeHelper
  include RedcarpetHelper

  # Create a session state and meta tag to be used as a cross-site-scripting token for Auth0 Lock widget.
  # Example:
  # <meta name="state" content="2c441e3e52d9928e299738d87c0612b2ed580a36e4a4770c" />
  #
  def state_meta_tag
    state = SecureRandom.hex(24)
    session['omniauth.state'] = state
    tag('meta', name: 'state', content: state)
  end

end
