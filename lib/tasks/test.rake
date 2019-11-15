namespace :development do
  desc "TODO"
  task random: :environment do
  	raffles = []
    progress_bar = ProgressBar.new(1000)
    puts "creating raffles array..."
    0.upto(999){ |idx|
      @userId =  Random.rand(1..User.count-1)
      @toRaffleUsers = User.where.not(id: @userId).to_a
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
      progress_bar.increment
    }
    puts "\nsaving raffles to database..."
    raffle = Raffle.create(raffles)
    puts "done!"
  end

  def getUserStatistic userId
    calculate_percentage(getSortsCountForUser(userId), getRafflesNumber)
  end

  def getSortsCountForUser userId
    Raffle.where(first_raffle_id: userId).or(Raffle.where(second_raffle_id: userId)).count
  end

  def getRafflesNumber
    Raffle.count
  end

  class ProgressBar
    def initialize(total)
      @total   = total
      @counter = 1
    end

    def increment
      complete = sprintf("%#.2f%%", ((@counter.to_f / @total.to_f) * 100))
      print "\r\e[0K#{@counter}/#{@total} (#{complete})"
      @counter += 1
    end

  end

end
