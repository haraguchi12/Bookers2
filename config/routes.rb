Rails.application.routes.draw do
  get 'chats/show'
  get 'search/search'
  devise_for :users,controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
  }

 root to: 'homes#top'
 get  "/home/about" =>"homes#about"
 get '/search', to: 'search#search'
 get 'chat/:id' => 'chats#show', as: 'chat'
 resources :books, only: [:new, :create, :index, :show, :destroy, :edit,:update] do
   resource :favorites, only: [:create, :destroy]
   resources :book_comments, only: [:create, :destroy]
   resources :chats, only: [:create]

 end
 resources :users, only: [:show, :edit, :update, :index] do
 resource :relationships, only: [:create, :destroy]
 get 'followings' => 'relationships#followings', as: 'followings'
 get 'followers' => 'relationships#followers', as: 'followers'

end
end