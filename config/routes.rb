Rails.application.routes.draw do
  # /projects/varvet/godmin
  get "projects/:organization/:project", to: "application#project"
end
