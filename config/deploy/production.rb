set :stage, :production
server ENV["PRODUCTION_HOST"], roles: %i(web app db)
