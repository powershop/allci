class Registry
  def self.host
    ENV['REGISTRY_HOST'] || "localhost:5000"
  end

  def self.host_prefix
    "#{host}/"
  end
end
