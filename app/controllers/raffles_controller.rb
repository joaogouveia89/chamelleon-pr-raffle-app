class RafflesController < ApplicationController
  before_action :set_raffle, only: [:show, :edit, :update, :destroy]

  helper_method :getRafflesNumber, :getUserStatistic, :reset_raffles

  # GET /raffles
  # GET /raffles.json
  def index
    @raffles = Raffle.all
    @users = User.all.order("name ASC")
  end

  # GET /raffles/1
  # GET /raffles/1.json
  def show
  end

  # GET /raffles/new
  def new
    @raffle = Raffle.new
  end

  # GET /raffles/1/edit
  def edit
  end

  # POST /raffles
  # POST /raffles.json
  def create
    @raffle = Raffle.new(raffle_params)

    respond_to do |format|
      if @raffle.save
        format.html { redirect_to @raffle, notice: 'Raffle was successfully created.' }
        format.json { render :show, status: :created, location: @raffle }
      else
        format.html { render :new }
        format.json { render json: @raffle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /raffles/1
  # PATCH/PUT /raffles/1.json
  def update
    respond_to do |format|
      if @raffle.update(raffle_params)
        format.html { redirect_to @raffle, notice: 'Raffle was successfully updated.' }
        format.json { render :show, status: :ok, location: @raffle }
      else
        format.html { render :edit }
        format.json { render json: @raffle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /raffles/1
  # DELETE /raffles/1.json
  def destroy
    @raffle.destroy
    respond_to do |format|
      format.html { redirect_to raffles_url, notice: 'Raffle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def raffle
    #algorithm: https://stackoverflow.com/questions/1589321/adjust-items-chance-to-be-selected-from-a-list
    @userId =  params[:user]
    @toRaffleUsers = User.where.not(id: @userId).to_a
    #@RaffleElements = []
    @numberOfSorts = Raffle.count

    #@toRaffleUsers.each { |current|
    #  @RaffleElements << Element.new(current.id, calculate_percentage(Raffle.where(user_id: current.id).count, @numberOfSorts))
    #}

  #  @RaffleElements.sort_by!{ |m| m.occourencePercentage }

 #   length = @toRaffleUsers.count

    firstRaffled = Random.rand(0..@toRaffleUsers.length)
    firstRaffledId = @toRaffleUsers[firstRaffled].id

  #  idx = length * (1 - random) ** (0.5)
    
 #   idx = idx.round()

    firstRaffledUser = User.find(firstRaffledId)

    @toRaffleUsers.delete_at(firstRaffled)

    secondRaffled = Random.rand(0..@toRaffleUsers.length)
    secondRaffledId = @toRaffleUsers[secondRaffled].id

    secondRaffledUser = User.find(secondRaffledId)
    Raffle.transaction do
      firstRaffledObject = Raffle.new
      firstRaffledObject.user_id = firstRaffledUser.id
      secondRaffledObject = Raffle.new
      secondRaffledObject.user_id = secondRaffledUser.id
      firstRaffledObject.save
      secondRaffledObject.save
    end
    

    respond_to do |format|
      format.json { render json: {"raffled1": firstRaffledUser.name, "raffled2":  secondRaffledUser.name}}
    end
    
  end

  def getRafflesNumber
    Raffle.count / 2
  end

  def getUserStatistic userId
    calculate_percentage(Raffle.where(user_id: userId).count, getRafflesNumber)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_raffle
      @raffle = Raffle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def raffle_params
      params.require(:raffle).permit(:user_id)
    end

    def calculate_percentage(count, numberOfSorts)
      count*100/numberOfSorts
    end
end
