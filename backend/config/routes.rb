Rails.application.routes.draw do
  resources :operations, only: [] do
    collection do
      get 'all_departments'
      get 'departments_search_by'
    end
  end

  resources :employee, only: [] do
    collection do
      get  'all_employees'
      post 'hire'
      put 'update'
      delete 'delete'
      patch 'delete_soft'
    end
  end

  resources :position, only: [] do
    collection do
      get  'all'
    end
  end
end