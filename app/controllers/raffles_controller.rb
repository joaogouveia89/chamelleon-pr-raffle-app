class RafflesController < ApplicationController
  before_action :set_raffle, only: [:show, :edit, :update, :destroy]

  helper_method :getRafflesNumber, :getUserStatistic, :reset_raffles, :getSortsCountForUser, :getLastSortDate

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

    @userId =  params[:user]
    @toRaffleUsers = User.where.not(id: @userId).to_a

    raffles = []
    @numberOfSorts = Raffle.count

    firstRaffledIndex = Random.rand(0..@toRaffleUsers.length-1)
  
    firstRaffledUser = @toRaffleUsers[firstRaffledIndex]

    @toRaffleUsers.delete_at(firstRaffledIndex)

    secondRaffledIndex = Random.rand(0..@toRaffleUsers.length-1)
    secondRaffledUser = @toRaffleUsers[secondRaffledIndex]
    r = {
      pr_owner_id: User.find(@userId).id,
      first_raffle_id: firstRaffledUser.id,
      second_raffle_id: secondRaffledUser.id
    }
    raffles << r
    raffle = Raffle.create(raffles)

    respond_to do |format|
      format.json { render json: {"raffled1": firstRaffledUser.name, "raffled2":  secondRaffledUser.name}}
    end
    
  end

  def getRafflesNumber
    Raffle.count
  end

  def getSortsCountForUser userId
    Raffle.where(first_raffle_id: userId).or(Raffle.where(second_raffle_id: userId)).count
  end

  def getUserStatistic userId
    calculate_percentage(getSortsCountForUser(userId), getRafflesNumber)
  end

  def getLastSortDate userId
    lastRaffle = Raffle.where(first_raffle_id: userId).or(Raffle.where(second_raffle_id: userId)).order("created_at DESC").first
    if(lastRaffle == nil)
      "Ainda não sorteado"
    else
      "Ultimo sorteio no dia " + lastRaffle.created_at.strftime("%d - %m - %Y")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_raffle
      @raffle = Raffle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def raffle_params
      params.require(:raffle).permit(:first_raffle_id, :second_raffle_id)
    end

    def calculate_percentage(count, numberOfSorts)
      count*100/numberOfSorts
    end
end
