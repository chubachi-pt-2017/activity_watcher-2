json.extract! team, :id, :name, :description, :repository_name, :service_url, :ci_url, :created_at, :updated_at
json.url team_url(team, format: :json)