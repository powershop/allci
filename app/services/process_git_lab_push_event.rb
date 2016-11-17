class ProcessGitLabPushEvent < ProcessGitPushEvent
  def initialize(post_data)
    @post_data = post_data
  end

  def json
    @json ||= JSON.parse(@post_data)
  end

  def uri
    json["repository"]["git_ssh_url"] if json["repository"]
  end

  def default_name
    json["repository"]["name"] if json["repository"]
  end

  def branch
    json["ref"]
  end

  def head_commit
    json["after"]
  end
end
