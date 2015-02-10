class CacheBusterJob < Que::Job

  def run(id)
    hit = CacheBuster.find(id)
  end

end
