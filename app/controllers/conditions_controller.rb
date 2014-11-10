class ConditionsController < ApplicationController
  include ConditionHelper

  before_filter do
    # A canned activity schema, guaranteed to be available because it's in seeds.rb
    @default_activity ||= ActivitySchema.first
    # Canned learners, guaranteed to be available because of seeds.rb
    @test_learners ||= Learner.where :for_testing => true
  end
  
  # GET /conditions
  def index
    @conditions = Condition.all
  end

  # GET /conditions/1
  def show
    @condition = Condition.find(params[:id])
  end

  # GET /conditions/new
  def new
    @condition = Condition.new
  end

  # GET /conditions/1/edit
  def edit
    @condition = Condition.find(params[:id])
  end

  # POST /conditions
  def create
    if params[:condition][:time_filler] != ""
      params[:condition][:time_filler] = ActivitySchema.find(params[:condition][:time_filler].to_i)
    else
      params[:condition][:time_filler] = nil
    end
    #to handle the collection_select to object array
    @prologue=params[:condition][:prologue_pages]
    @body=params[:condition][:body_pages]
    @epilogue=params[:condition][:epilogue_pages]
    params[:condition][:prologue_pages] = array_for(@prologue) unless @prologue == nil
    params[:condition][:body_pages] = array_for(@body) unless  @body == nil
    params[:condition][:epilogue_pages] = array_for(@epilogue) unless @epilogue == nil 
    @condition = Condition.new(params[:condition])
    if @condition.save
      redirect_to @condition, notice: 'Condition was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /conditions/1
  def update
    @condition = Condition.find(params[:id])
    if params[:condition][:time_filler] != ""
      params[:condition][:time_filler] = ActivitySchema.find(params[:condition][:time_filler].to_i)
    else
      params[:condition][:time_filler] = nil
    end
    #to handle the collection_select to object array
    @prologue=params[:condition][:prologue_pages]
    @body=params[:condition][:body_pages]
    @epilogue=params[:condition][:epilogue_pages]
    params[:condition][:prologue_pages] = array_for(@prologue) unless @prologue == nil
    params[:condition][:body_pages] = array_for(@body) unless  @body == nil
    params[:condition][:epilogue_pages] = array_for(@epilogue) unless @epilogue == nil 
    
    if @condition.update_attributes(params[:condition])
      redirect_to @condition, notice: 'Condition was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /conditions/1
  def destroy
    @condition = Condition.find(params[:id])
    @condition.destroy
    redirect_to conditions_url 
  end
end
