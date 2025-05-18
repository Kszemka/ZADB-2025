Rails.application.routes.draw do
  resources :employee, only: [] do
    collection do
      get  'all_employees'
      post 'hire'
      put 'update'
      delete 'delete'
    end
  end

  resources :position, only: [] do
    collection do
      get  'all'
    end
  end
end