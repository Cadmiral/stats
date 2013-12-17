class BoxscoresController < ApplicationController
  before_action :set_boxscore, only: [:show, :edit, :update, :destroy]

  # GET /boxscores
  # GET /boxscores.json
  def index
    @boxscores = Boxscore.all
  end

  # GET /boxscores/1
  # GET /boxscores/1.json
  def show
  end

  # GET /boxscores/new
  def new
    @boxscore = Boxscore.new
  end

  # GET /boxscores/1/edit
  def edit
  end

  # POST /boxscores
  # POST /boxscores.json
  def create
    @boxscore = Boxscore.new(boxscore_params)

    respond_to do |format|
      if @boxscore.save
        format.html { redirect_to @boxscore, notice: 'Boxscore was successfully created.' }
        format.json { render action: 'show', status: :created, location: @boxscore }
      else
        format.html { render action: 'new' }
        format.json { render json: @boxscore.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boxscores/1
  # PATCH/PUT /boxscores/1.json
  def update
    respond_to do |format|
      if @boxscore.update(boxscore_params)
        format.html { redirect_to @boxscore, notice: 'Boxscore was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @boxscore.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boxscores/1
  # DELETE /boxscores/1.json
  def destroy
    @boxscore.destroy
    respond_to do |format|
      format.html { redirect_to boxscores_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_boxscore
      @boxscore = Boxscore.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def boxscore_params
      params[:boxscore]
    end
end
