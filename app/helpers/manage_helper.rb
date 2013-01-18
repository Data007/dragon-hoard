module ManageHelper
  def back_button
    return raw('<a onclick="javascript:history.back()" class="icon-arrow-left-3 page-back" />')
  end
end
