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
  
  def newEvent
    @event = Event.new
    @event = params[:id]
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
  
  def execute
    @transaction = Transaction.find(params[:id])
    @transaction.events.each do | event|
      case event.language
      when 1  #ruby
        puts event.code 
        @result = eval(event.code)
        @transaction.answer = @result
        @transaction.save
        @answer = Answer.new
        @answer.response = @transaction.answer
        
        respond_to do |wants|
          wants.html
          wants.js
          wants.xml { render :xml => @answer.to_xml }
        end
      end
    end
  end
  
  def list
  # wants is determined by the http Accept header in the request
    @transaction = Transaction.all
    respond_to do |wants|
      wants.html
      wants.js
      wants.xml { render :xml => @transaction.to_xml }
    end    
  end
  
  
  














 
  
end
