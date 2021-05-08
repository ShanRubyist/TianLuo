module ApplicationHelper
  # def authenticate_admin!
  #   redirect_to root_path unless current_user.admin?
  # end

  # 加载 VUE 组件的 template 内容
  def import_partial(partial)
    # 把 template 内容去除空白字符拼成一行
    res = render(partial).split("\n").join('')
    raw(res)
  end

  def present(object, locals = nil, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, locals, self)
    yield presenter if block_given?
    presenter
  end
end
