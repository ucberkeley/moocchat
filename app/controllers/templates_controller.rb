class TemplatesController < ApplicationController
  # GET /templates
  def index
    @templates = Template.all
  end

  # GET /templates/1
  def show
    @template = Template.find(params[:id])
    # set up some variables that would normally be setup by
    # TasksController#page, and preview the template
    @question = Question.first
    @question_counter = 1
    @start_form_tag = view_context.form_tag(templates_path, :method => :get)
    @counter = @subcounter = 1
    @data = @u = {}             # user data/state
    @me = 0
    @preview = true             # prevents timer from counting
    render :inline => @template.html, :layout => @false
  end

  # GET /templates/new
  # GET /templates/new.json
  def new
    @template = Template.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @template }
    end
  end

  # GET /templates/1/edit
  def edit
    @template = Template.find(params[:id])
  end

  # POST /templates
  def create
    @template = Template.new(params[:template])
    if @template.save
      redirect_to templates_path, notice: 'Template was successfully created.' 
    else
      render action: "new"
    end
  end

  # PUT /templates/1
  # PUT /templates/1.json
  def update
    @template = Template.find(params[:id])
    if @template.update_attributes!(params[:template])
      redirect_to templates_path, notice: 'Template was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    @template = Template.find(params[:id])
    redirect to templates_path
  end

  private
  def template_params
      params.require(:template).permit(:name,:url,:html)
   end
end
