module ApplicationHelper
  def authenticate_admin!
    redirect_to root_path unless current_user.admin?
  end

  # 加载 VUE 组件的 template 内容
  def import_partial(partial)
    # 把 template 内容去除空白字符拼成一行
    res = render(partial).split("\n").join('')
    raw(res)
  end
end
