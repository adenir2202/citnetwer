class TransactionsController < ApplicationController

  def index
    @transactions = Transaction.all
  end
  
  def show
    @transaction = Transaction.find(params[:id])
  end
  
  def new
    @transaction = Transaction.new  
  end
  
  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.save
    
    redirect_to transaction_path(@transaction)
  end
  
  def transaction_params
    params.require(:transaction).permit(:code, :name, :description, :argument, :answerType, :answer)
  
  end
    
  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy
    flash.notice = "transaction '#{@transaction.name}' Deleted!"
    redirect_to action: 'index'   
  end
  
  def edit
    @transaction = Transaction.find(params[:id])
  end
  
  
  def update
    @transaction = Transaction.find(params[:id])
    @transaction.update(transaction_params)
    flash.notice = "transaction '#{@transaction.name}' Updated!"
    
    redirect_to transaction_path(@transaction)
  end
  
end
