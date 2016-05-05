module PagesHelper

	def team_members
		data = YAML.load_file Rails.root.join('lib', 'data', 'team.yml')
		data['team_members']
	end

	def how_it_works_text_for(role, locale=:it)
		data = YAML.load_file Rails.root.join('lib', 'data', 'how_it_works.yml')
		data[locale.to_s][role.to_s].html_safe
	end
end
