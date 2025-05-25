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
      get 'search'
      get 'projects'
      get 'history'
      put 'give_raise_for_all'
    end
  end

  resources :position, only: [] do
    collection do
      get  'all'
      get  'withDetails'
      get  'search_by'
      post 'create'
    end
  end
end