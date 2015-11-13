Rails.application.routes.draw do
  get "projects/:organization/:project", to: redirect("projects/%{organization}/%{project}/master")
  get "projects/:organization/:project/:version", to: "application#project", constraints: { version: /[^\/]+/ }
end
