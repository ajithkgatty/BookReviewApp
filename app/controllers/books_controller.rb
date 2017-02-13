class BooksController < ApplicationController
	before_action :find_book, only: [:update, :show, :edit, :destroy]
  def index
    if params[:category].blank?
  	@books = Book.all.order("created_at DESC")
  else
    @category_id = Category.find_by_name(params[:category]).id
    @books = Book.where(category_id: @category_id).order("created_at DESC")

  end
  end

  def new
  	@book = current_user.books.build
    @categories = Category.all.map { |c| [c.name, c.id]}
  end

  def create
  	@book = current_user.books.build(book_params)
    @book.category_id = params[:category_id]
  	if @book.save
  		redirect_to root_path 
  	else
  		render 'new'
  	end
  end

  def show
  end

  def update
    @book.category_id = params[:category_id]
  	if @book.update_attributes(book_params)
  		redirect_to book_path(@book)
  	else
  		render 'edit'
  	end
  end

  def edit
    @categories = Category.all.map { |c| [c.name, c.id]}
  end

  def destroy
  	if @book.destroy
  		redirect_to books_path
  	end

  end




  private
  def book_params
  	params.require(:book).permit(:title, :description, :author, :category_id)
  end

  def find_book
  	@book = Book.find(params[:id])
  end

end
