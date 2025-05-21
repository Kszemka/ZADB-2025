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
      get 'inner_join'
      get 'left_join'
      get 'right_join'
      get 'full_outer_join'
      get 'cross_join'
    end
  end

  resources :position, only: [] do
    collection do
      get  'all'
      get  'withDetails'
    end
  end
end