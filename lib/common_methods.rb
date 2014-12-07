module CommonMethods
  def not_null(option_1,option_2)
    if (option_1 == nil || option_1.empty?)
      return option_2
    else
      return option_1
    end
  end
end