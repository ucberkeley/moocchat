class ActivitySchemasController < ApplicationController
  # GET /activity_schemas
  # GET /activity_schemas.json
  def index
    @activity_schemas = ActivitySchema.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @activity_schemas }
    end
  end

  # GET /activity_schemas/1
  # GET /activity_schemas/1.json
  def show
    @activity_schema = ActivitySchema.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @activity_schema }
    end
  end

  # GET /activity_schemas/new
  # GET /activity_schemas/new.json
  def new
    @activity_schema = ActivitySchema.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @activity_schema }
    end
  end

  # GET /activity_schemas/1/edit
  def edit
    @activity_schema = ActivitySchema.find(params[:id])
  end

  # POST /activity_schemas
  # POST /activity_schemas.json
  def create
    @activity_schema = ActivitySchema.new(params[:activity_schema])

    respond_to do |format|
      if @activity_schema.save!
        format.html { redirect_to @activity_schema, notice: 'Activity schema was successfully created.' }
        format.json { render json: @activity_schema, status: :created, location: @activity_schema }
      else
        format.html { render action: "new" }
        format.json { render json: @activity_schema.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /activity_schemas/1
  # PUT /activity_schemas/1.json
  def update
    @activity_schema = ActivitySchema.find(params[:id])

    respond_to do |format|
      if @activity_schema.update_attributes!(params[:activity_schema])
        format.html { redirect_to @activity_schema, notice: 'Activity schema was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @activity_schema.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_schemas/1
  # DELETE /activity_schemas/1.json
  def destroy
    @activity_schema = ActivitySchema.find(params[:id])
    @activity_schema.destroy

    respond_to do |format|
      format.html { redirect_to activity_schemas_url }
      format.json { head :no_content }
    end
  end
end
