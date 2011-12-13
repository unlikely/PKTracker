load 'deploy' if respond_to?(:namespace) # cap2 differentiator
load 'config/deploy/deploy.rb'
Dir['config/deploy/*_recipes.rb'].each do |f|
  load f
end
