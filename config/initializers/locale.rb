require 'i18n/backend/fallbacks'

I18n.available_locales = [
  :en,  # American English
  :uk   # British English [UK] - NOT Ukraine which is normally associated with :uk locale.
]

I18n.default_locale = :en

I18n.backend.class.send(:include, I18n::Backend::Fallbacks)
I18n.fallbacks.map(uk: :en)
