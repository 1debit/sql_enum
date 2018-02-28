class Array
  def fetch(key, default)
    key if self.include?(key)
  end
end
