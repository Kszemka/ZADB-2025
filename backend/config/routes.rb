Rails.application.routes.draw do
  resources :employee, only: [] do
    collection do
      get  'all_employees'
      post 'hire'
    end
  end
end