# Include the migrations defined in the core engine
Rails.application.config.paths["db/migrate"] << File.expand_path("../../../../../../core/db/migrate", __FILE__)
