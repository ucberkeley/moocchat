module TemplateHelper
  def index_to_letter(num)
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ'[[index,25].min]
  end
end
