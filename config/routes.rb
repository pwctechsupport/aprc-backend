Rails.application.routes.draw do
  # mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  mount GraphqlPlayground::Rails::Engine, at: "/graphql_playground", graphql_path: "/graphql"
  post "/graphql", to: "graphql#execute"
  devise_for :users
  namespace :api do
    resources :references do
      collection do
        put 'import'
      end
    end
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
        get 'report_risk_policy', to: "prints#report_risk_policy", as: :report_risk_policy
        get 'report_control_policy', to: "prints#report_control_policy", as: :report_control_policy
        get 'unmapped_risk', to: "prints#unmapped_risk", as: :unmapped_risk
        get 'unmapped_control', to: "prints#unmapped_control", as: :unmapped_control
        get 'report_resource_rating', to: "prints#report_resource_rating", as: :report_resource_rating
        get 'business_process_excel', to: "prints#business_process_excel", as: :business_process_excel
        get 'risk_excel', to: "prints#risk_excel", as: :risk_excel
        get 'policy_category_excel', to: "prints#policy_category_excel", as: :policy_category_excel
        get 'control_excel', to: "prints#control_excel", as: :control_excel
        get 'resource_excel', to: "prints#resource_excel", as: :resource_excel
        get 'reference_excel', to: "prints#reference_excel", as: :reference_excel
      end
      member do
        get :control
        get :risk
        get :policy, to: "prints#policy", as: :policy
        get 'report', to: "prints#report", as: :report
        get 'business_process', to: "prints#business_process", as: :business_process
        get 'business_process_control', to: "prints#business_process_control", as: :business_process_control

      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
