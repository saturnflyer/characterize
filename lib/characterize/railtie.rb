module Characterize
  class Railtie < ::Rails::Railtie
    config.after_initialize do |app|
      app.config.paths.add "app/characters", eager_load: true
    end

    if defined?(ActiveRecord)
      initializer "characterize.active_record" do |app|
        ActiveRecord::Base.send(:include, Characterize)
      end
    end

    if defined?(Mongoid)
      initializer "characterize.mongoid" do |app|
        Mongoid::Document.send(:include, Characterize)
      end
    end

    initializer "characterize.action_controller" do |app|
      ActionController::Base.send(:include, Characterize::Controller)
    end
  end
end
