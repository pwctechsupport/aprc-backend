Rails.application.routes.draw do
  # mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  mount GraphqlPlayground::Rails::Engine, at: "/graphql_playground", graphql_path: "/graphql"
  post "/graphql", to: "graphql#execute"
  devise_for :users
  namespace :api do
    resources :prints do
      member do
        get :control
        get :risk
        get 'report_policy', to: "prints#report_policy", as: :report_policy
        get 'report', to: "prints#report", as: :report
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
