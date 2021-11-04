Rails.application.routes.draw do
  get 'logout/index'
  get 'register/index'
  get 'forget_account/index'
  get 'dashboard_aluno/index'
  get 'aluno/index'
  get 'login/index'
  post 'login', to: 'login#create'
  post 'dashboard_aluno', to: 'dashboard_aluno#create'


  get 'home/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
