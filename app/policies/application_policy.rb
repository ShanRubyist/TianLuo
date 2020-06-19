class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  ['dashboard',
   'index',
   'new',
   'create',
   'show',
   'edit',
   'update',
   'delete',
   'destroy',
   'export',
   'bulk_delete',
   'show_in_app'].each do |method|
    define_method "#{method}?" do
      user.admin?
    end
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
