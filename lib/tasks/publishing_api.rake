namespace :publishing_api do
  task publish: [:environment] do
    PublishingApiNotifier.new.publish
  end
end
