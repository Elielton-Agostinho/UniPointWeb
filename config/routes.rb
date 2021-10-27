Rails.application.routes.draw do
  get 'register/index'
  get 'forget_account/index'
  get 'dashboard_aluno/index'
  get 'aluno/index'
  get 'login/index'
  post 'login', to: 'login#create'


  get 'home/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
