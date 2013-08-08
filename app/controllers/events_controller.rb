class EventsController < ApplicationController

  def index
    @events = Event.all
  end
  
  def show
    @event = Event.find(params[:id])
  end
  
  def new
    @event = Event.new  
    @event.transaction_id = params[:id]
  end
    
  def create
    @event = Event.new(event_params)
    @event.save
    flash.notice = "Event '#{event_params}' Created"
    
    redirect_to event_path(@event)
  end
  
  def event_params
    params.require(:event).permit(:code, :name, :argument, :language, :answerType, :answer, :transaction_id)
  
  end
    
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    flash.notice = "Event '#{@event.name}' Deleted!"
    redirect_to action: 'index'   
  end
  
  def edit
    @event = Event.find(params[:id])
  end
  
  
  def update
    @event = Event.find(params[:id])
    @event.update(event_params)
    flash.notice = "Event '#{@event.code}' Updated!"
    
    redirect_to event_path(@event)
  end
  
end
