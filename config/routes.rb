Rails.application.routes.draw do

  get 'login_prof/index'
  get 'professor/index'
  get 'logout/index'
  get 'register/index'
  get 'forget_account/index'
  get 'dashboard_aluno/index'
  get 'aluno/index'
  get 'login/index'

  post 'login', to: 'login#create'
  post 'login_prof', to: 'login_prof#create'
  post 'dashboard_aluno', to: 'dashboard_aluno#create'
  post 'login', to: 'login#create'
  post 'presenca', to: 'presenca#create'
  post 'professor', to: 'professor#create'
  post 'abrir_presenca', to: 'abrir_presenca#create'


  get 'home/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
