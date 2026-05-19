class TodoItemsController < ApplicationController
  #πριν από κάθε action ελέγχεται αν ο χρήστης είναι συνδεδεμένος
  before_action :authorize_request
  #φορτώνεται το todo στο οποίο ανήκει το item
  before_action :set_todo
  #φορτώνεται το συγκεκριμένο item για τα actions που το χρειάζονται
  before_action :set_todo_item, only: [:show, :update, :destroy]

  # GET /todos/:id/items/:iid 
  def show
    render json: @todo_item, status: :ok
  end

  # POST /todos/:id/items 
  def create
    todo_item = @todo.todo_items.new(todo_item_params)

    if todo_item.save
      render json: todo_item, status: :created
    else
      render json: { errors: todo_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /todos/:id/items/:iid 
  def update
    if @todo_item.update(todo_item_params)
      render json: @todo_item, status: :ok
    else
      render json: { errors: @todo_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /todos/:id/items/:iid 
  def destroy
    @todo_item.destroy
    render json: { message: 'Todo item deleted successfully' }, status: :ok
  end

  private

  def set_todo
    #αναζήτηση του todo μονο μέσα στα todos του συνδεδεμένου χρήστη
    @todo = @current_user.todos.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Todo not found' }, status: :not_found
  end

  def set_todo_item
  #αναζήτηση του item με βάση το :iid από το URL
  @todo_item = @todo.todo_items.find_by(id: params[:iid])

  #404 εαν δεν βρεθεί το item
  unless @todo_item
    render json: { error: 'Todo item not found' }, status: :not_found
  end
end

  def todo_item_params
    # μόνο content και completed
    params.require(:todo_item).permit(:content, :completed)
  end
end