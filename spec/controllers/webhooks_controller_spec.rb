require 'rails_helper'

RSpec.describe WebhooksController, type: :controller do
  describe "#github" do
    context "push events" do
      before do
        request.headers['X-GitHub-Event'] = 'push'
      end

      it "receives github push events and passes the data to ProcessGitHubPushEvent" do
        request.env['RAW_POST_DATA'] = "dummy data"
        instance = instance_double(ProcessGitHubPushEvent)
        expect(ProcessGitHubPushEvent).to receive(:new).with("dummy data").and_return(instance)
        expect(instance).to receive(:call)

        post :github
      end
    end

    context "other events" do
      before do
        request.headers['X-GitHub-Event'] = 'Issue Hook'
      end

      it "ignores the event" do
        request.env['RAW_POST_DATA'] = "dummy data"
        expect(ProcessGitHubPushEvent).not_to receive(:new)

        post :github
      end
    end
  end

  describe "#gitlab" do
    context "push events" do
      before do
        request.headers['X-Gitlab-Event'] = 'Push Hook'
      end

      it "receives gitlab push events and passes the data to ProcessGitLabPushEvent" do
        request.env['RAW_POST_DATA'] = "dummy data"
        instance = instance_double(ProcessGitLabPushEvent)
        expect(ProcessGitLabPushEvent).to receive(:new).with("dummy data").and_return(instance)
        expect(instance).to receive(:call)

        post :gitlab
      end
    end

    context "other events" do
      before do
        request.headers['X-Gitlab-Event'] = 'Issue Hook'
      end

      it "ignores the event" do
        request.env['RAW_POST_DATA'] = "dummy data"
        expect(ProcessGitLabPushEvent).not_to receive(:new)

        post :gitlab
      end
    end
  end
end
