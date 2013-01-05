class Env
  def initialize(default = nil, outer = nil)
    @hash = Hash.new(default)
    @outer = outer
  end

  def get(key)
    @hash.has_key?(key) ? @hash[key] : @outer.find(key)
  end

  def set(key, value)
    @hash[key] = value
  end

  def update(hash)
    @hash.merge!(hash)
  end
end
