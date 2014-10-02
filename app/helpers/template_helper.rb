module TemplateHelper
  def index_to_letter(num)
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ'[[num,25].min]
  end
end
