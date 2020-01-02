Rails.application.routes.draw do
  if Rails.env.development?
    # mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
    mount GraphqlPlayground::Rails::Engine, at: "/graphql_playground", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  devise_for :users
  namespace :api do
    resources :prints do
      collection do
        get 'report_risk_excel', to: "prints#report_risk_excel", as: :report_risk_excel
        get 'report_risk', to: "prints#report_risk", as: :report_risk
      end
      member do
        get :control
        get :risk
        get 'report', to: "prints#report", as: :report
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
