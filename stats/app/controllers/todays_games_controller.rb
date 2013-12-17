class TodaysGamesController < ApplicationController
  before_action :set_todays_game, only: [:show, :edit, :update, :destroy]

  # GET /todays_games
  # GET /todays_games.json
  def index
    @todays_games = TodaysGame.all
  end

  # GET /todays_games/1
  # GET /todays_games/1.json
  def show
  end

  # GET /todays_games/new
  def new
    @todays_game = TodaysGame.new
  end

  # GET /todays_games/1/edit
  def edit
  end

  # POST /todays_games
  # POST /todays_games.json
  def create
    @todays_game = TodaysGame.new(todays_game_params)

    respond_to do |format|
      if @todays_game.save
        format.html { redirect_to @todays_game, notice: 'Todays game was successfully created.' }
        format.json { render action: 'show', status: :created, location: @todays_game }
      else
        format.html { render action: 'new' }
        format.json { render json: @todays_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todays_games/1
  # PATCH/PUT /todays_games/1.json
  def update
    respond_to do |format|
      if @todays_game.update(todays_game_params)
        format.html { redirect_to @todays_game, notice: 'Todays game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @todays_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todays_games/1
  # DELETE /todays_games/1.json
  def destroy
    @todays_game.destroy
    respond_to do |format|
      format.html { redirect_to todays_games_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todays_game
      @todays_game = TodaysGame.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def todays_game_params
      params[:todays_game]
    end
end
