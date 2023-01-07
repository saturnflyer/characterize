module UserCharacter
  def each_widget(&block)
    each_with_features(widgets, TestingCharacter, &block)
  end
end
