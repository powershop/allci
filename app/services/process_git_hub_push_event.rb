class ProcessGitHubPushEvent < ProcessGitPushEvent
  def initialize(post_data)
    @post_data = post_data
  end

  def json
    @json ||= JSON.parse(@post_data)
  end

  def uri
    json["repository"]["ssh_url"] if json["repository"]
  end

  def default_name
    json["repository"]["name"] if json["repository"]
  end
end
