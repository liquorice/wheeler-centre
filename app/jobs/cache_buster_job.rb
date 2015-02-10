require 'digest/md5'

class CacheBusterJob < Que::Job

  def run(id)
    @hit = CacheBuster.find(id)
    @uri = "http://#{ENV['CDN_ORIGIN']}#{@hit.path}"

    request_page
    purge_page if @hit.checksum != @checksum
    update_hit

    p "Hit for page #{@hit.path} processed!"
  end

  def request_page
    basic_auth_user     = ENV['BASIC_AUTH_USER']
    basic_auth_password = ENV['BASIC_AUTH_PASSWORD']

    source = if basic_auth_password && basic_auth_user
      Nokogiri::HTML(open(
        @uri,
        http_basic_authentication: [basic_auth_user, basic_auth_password]
      ))
    else
      Nokogiri::HTML(open(@uri))
    end

    @checksum = Digest::MD5.hexdigest(source)
  end

  def purge_page
    client = Varnisher::Purger.new('PURGE', @hit.path, ENV['CDN_HOST'])
    purge = client.send
    p "Purging status: #{purge}"
  end

  def update_hit
    @hit.update(checksum: @checksum)
  end

end
