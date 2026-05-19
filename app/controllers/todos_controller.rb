class TodosController < ApplicationController
  # πριν από κάθε action ελέγχεται αν ο χρήστης είναι συνδεδεμένος
  before_action :authorize_request
  #το υγκεκριμένο todo φορτώνεται για τα actions που το χρειάζονται
  before_action :set_todo, only: [:show, :update, :destroy]

  # GET /todos 
  def index
    todos = @current_user.todos.includes(:todo_items)
    render json: todos.as_json(include: :todo_items), status: :ok
  end

  # POST /todos
  def create
    todo = @current_user.todos.new(todo_params)

    if todo.save
      render json: todo, status: :created
    else
      #422 αν υπάρχει σφάλμα 
      render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /todos/:id
  #επιστρέφεται ένα συγκεκριμένο todo με τα items του
  def show
    render json: @todo.as_json(include: :todo_items), status: :ok
  end

  # PUT /todos/:id 
  def update
    if @todo.update(todo_params)
      render json: @todo, status: :ok
    else
      render json: { errors: @todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /todos/:id
  def destroy
    @todo.destroy
    render json: { message: 'Todo deleted successfully' }, status: :ok
  end

  private

  def set_todo
    # ααζήτηση του todo μονο μέσα στα todos του συνδεδεμένου χρήστη
    @todo = @current_user.todos.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Todo not found' }, status: :not_found
  end

  def todo_params
    #μόνο title και description
    params.require(:todo).permit(:title, :description)
  end
end