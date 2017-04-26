module FontAwesome

  def fa_arrow_down(classes: [])
    create_tag 'fa-caret-down', classes
  end

  def fa_arrow_left(classes: [])
    create_tag 'fa-caret-left', classes
  end

  def fa_arrow_right(classes: [])
    create_tag 'fa-caret-right', classes
  end

  def fa_arrow_up(classes: [])
    create_tag 'fa-caret-up', classes
  end

  def fa_bars(classes: [])
    create_tag 'fa-bars', classes
  end

  def fa_edit(classes: [])
    create_tag 'fa-edit', classes
  end

  def fa_graduation_cap(classes: [])
    create_tag 'fa-graduation-cap', classes
  end

  def fa_key(classes: [])
    create_tag 'fa-key', classes
  end

  def fa_pencil(classes: [])
    create_tag 'fa-pencil', classes
  end

  def fa_plus(classes: [])
    create_tag 'fa-plus', classes
  end

  def fa_sign_out(classes: [])
    create_tag 'fa-sign-out', classes
  end

  def fa_sliders(classes: [])
    create_tag 'fa-sliders', classes
  end

  def fa_tachometer(classes: [])
    create_tag 'fa-tachometer', classes
  end

  def fa_user(classes: [])
    create_tag 'fa-user', classes
  end

  def fa_user_circle(classes: [])
    create_tag 'fa-user-circle', classes
  end

  def fa_user_circle_o(classes: [])
    create_tag 'fa-user-circle-o', classes
  end

  def fa_user_o(classes: [])
    create_tag 'fa-user-o', classes
  end

  def fa_user_plus(classes: [])
    create_tag 'fa-user-plus', classes
  end

  def fa_user_times(classes: [])
    create_tag 'fa-user-times', classes
  end

  def fa_users(classes: [])
    create_tag 'fa-users', classes
  end

  #---------------------------------------------------------------------------
  private

  def create_tag(name, classes)
    classes = classes.to_s.split ' ' unless classes.is_a? Array
    "<i class=\"#{%w[fa].push(name).push(classes).flatten.uniq.join(' ').strip}\" aria-hidden=\"true\"></i>".html_safe
  end

end
