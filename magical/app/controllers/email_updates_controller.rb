class EmailUpdatesController < ApplicationController
  # GET /email_updates
  # GET /email_updates.json
  def index
    @email_updates = EmailUpdate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @email_updates }
    end
  end

  # GET /email_updates/1
  # GET /email_updates/1.json
  def show
    @email_update = EmailUpdate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @email_update }
    end
  end

  # GET /email_updates/new
  # GET /email_updates/new.json
  def new
    @email_update = EmailUpdate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @email_update }
    end
  end

  # GET /email_updates/1/edit
  def edit
    @email_update = EmailUpdate.find(params[:id])
  end

  # POST /email_updates
  # POST /email_updates.json
  def create
    @email_update = EmailUpdate.new(params[:email_update])

    respond_to do |format|
      if @email_update.save
        @emailList = Email.pluck(:email)
        @emailList.each do |recipient|
          UserMailer.info_email(@email_update.subject, @email_update.message, recipient).deliver  
        end
        format.html { redirect_to @email_update, notice: 'Email update was successfully created.' }
        format.json { render json: @email_update, status: :created, location: @email_update }
      else
        format.html { render action: "new" }
        format.json { render json: @email_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /email_updates/1
  # PUT /email_updates/1.json
  def update
    @email_update = EmailUpdate.find(params[:id])

    respond_to do |format|
      if @email_update.update_attributes(params[:email_update])
        format.html { redirect_to @email_update, notice: 'Email update was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @email_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_updates/1
  # DELETE /email_updates/1.json
  def destroy
    @email_update = EmailUpdate.find(params[:id])
    @email_update.destroy

    respond_to do |format|
      format.html { redirect_to email_updates_url }
      format.json { head :no_content }
    end
  end
end
