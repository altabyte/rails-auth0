module RedcarpetHelper

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(markdown_options)
    markdown = Redcarpet::Markdown.new(renderer, markdown_extensions)
    markdown.render(markdown_preprocess(text)).html_safe
  end

  #---------------------------------------------------------------------------
  private

  def markdown_options
    {
      filter_html: true,
      hard_wrap: true,
      link_attributes: { rel: 'nofollow', target: '_blank' },
      space_after_headers: true,
      fenced_code_blocks: true
    }
  end

  def markdown_extensions
    {
      autolink: true,
      superscript: true,
      disable_indented_code_blocks: true
    }
  end

  # Preprocess the text string to expand ${variables} and %{translations}.
  def markdown_preprocess(text)
    text.gsub!(/%\{([^}]*?)\}/) { I18n.translate Regexp.last_match[1] }

    # Look up table can be used to perform calculations or database/redis look-ups
    lut = {
      'locale'            => I18n.locale,
      'organization-name' => 'Ruby Dev',
      'example-redis-key' => Redis.current.get('abc') || 'def'
    }
    text.gsub!(/\$\{([^}]*?)\}/) { lut.fetch Regexp.last_match[1], '' }
    text
  end

end
