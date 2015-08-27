module PagesHelper

	def team_members
		data = YAML.load_file Rails.root.join('lib', 'data', 'team.yml')
		data['team_members']
	end
end
