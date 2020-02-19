Rails.application.routes.draw do
  # mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  mount GraphqlPlayground::Rails::Engine, at: "/graphql_playground", graphql_path: "/graphql"
  post "/graphql", to: "graphql#execute"
  devise_for :users
  namespace :api do
    resources :resources do
      collection do
        put 'import'
      end
    end
    resources :controls do
      collection do
        put 'import'
      end
    end
    resources :risks do
      collection do
        put 'import'
      end
    end
    resources :policy_categories do
      collection do
        put 'import'
      end
    end
    resources :business_processes do
      collection do
        put 'import'
      end
    end
    resources :prints do
      collection do
        get 'report_risk_excel', to: "prints#report_risk_excel", as: :report_risk_excel
        get 'report_risk', to: "prints#report_risk", as: :report_risk
        get 'business_process_excel', to: "prints#business_process_excel", as: :business_process_excel
        get 'risk_excel', to: "prints#risk_excel", as: :risk_excel
        get 'policy_category_excel', to: "prints#policy_category_excel", as: :policy_category_excel
        get 'control_excel', to: "prints#control_excel", as: :control_excel
        get 'resource_excel', to: "prints#resource_excel", as: :resource_excel
      end
      member do
        get :control
        get :risk
        get 'report', to: "prints#report", as: :report
        get 'business_process', to: "prints#business_process", as: :business_process
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
