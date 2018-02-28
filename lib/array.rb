Array.class_eval do
  def fetch(key, default)
    key if self.include?(key&.to_s)
  end
end
