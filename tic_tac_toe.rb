# Defining the player name and marker
class Player
    attr_reader :name
    attr_accessor :marker
  
    @@player_count = 1
  
    def initialize(name = 'Unknown', marker = 'Unknown')
      @name = name
      @marker = marker
      @@player_count += 1
    end
  
    # Setup each player with a name and marker
    def self.player_setup
      puts "Hello Player #{@@player_count}, please enter your name:"
      player_name = gets.chomp
      puts "#{player_name}, please choose a character as your board marker:"
      player_marker = gets.chomp
      Player.new(player_name, player_marker)
    end
  
    def self.reset_count
      @@player_count = 1
    end
  end
  
  # Class: Game of Tic-Tac-Toe
  class GameBoard < Player
    attr_accessor :round
    attr_reader :player1, :player2, :player_no
  
    def initialize
      @player1 = Player.player_setup
      @player2 = Player.player_setup
      self.round = 9
      @markers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
      @player1_markers = []
      @player2_markers = []
      @winning_combos = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
      @continue_game = true
    end
  
    private
  
    # Prints the current state of the board
    def game_board_state
      puts "
         #{@markers[0]} | #{@markers[1]} | #{@markers[2]}
        ---+---+---
         #{@markers[3]} | #{@markers[4]} | #{@markers[5]}
        ---+---+---
         #{@markers[6]} | #{@markers[7]} | #{@markers[8]}\n\n"
    end
  
    public
  
    # Determines if another round will commence
    def game_round?
      player_turn while round.positive? && @continue_game == true
  
      return unless round.zero?
  
      puts "It's a draw!"
      @continue_game = false
      replay_game
    end
  
    private
  
    # Decides whether it's player 1 or player 2's turn
    def player_turn
      if round.odd?
        @player_no = player1
        @player_no_marker = @player1_markers
      elsif round.even?
        @player_no = player2
        @player_no_marker = @player2_markers
      end
  
      choose_marker_placement
    end
  
    # The player decides where to place their marker on the board
    def choose_marker_placement
      game_board_state
      puts "#{player_no.name} it's your turn. Select a number from the board (1-9) to claim with your marker:"
      @player_input = gets.chomp.to_i
      marker_placement
    end
  
    # Places a players marker onto the board
    def marker_placement
      @markers.each_index do |element|
        if !@markers[element].is_a? Integer
          if element + 1 == @player_input
            puts 'This space has been taken, please try again'
          end
          next
        elsif element + 1 == @player_input
          @markers[element] = player_no.marker
          self.round -= 1
          element += 1
          sort_player_markers(element)
        end
      end
    end
  
    # Adds the players marker into their own arrays for comparison against winning conditions
    def sort_player_markers(number)
      if player_no.marker == player1.marker
        @player1_markers.push(number)
      elsif player_no.marker == player2.marker
        @player2_markers.push(number)
      else
        puts 'Something has gone wrong!'
      end
  
      declare_winner
    end
  
    # Checks each round if the player meets the winning conditions
    def declare_winner
      @winning_combos.each do |win_condition|
        if (win_condition - @player_no_marker).empty?
          game_board_state
          puts "Winner!, #{player_no.name}'s winning combination: #{win_condition}"
          @continue_game = false
          replay_game
        end
      end
    end
  
    # Once the game has finished, the players can restart the game
    def replay_game
      return unless @continue_game == false
  
      puts "If you would like to replay the game, select 'R' on your keyboard"
      replay = gets.chomp.downcase
      return unless replay == 'r'
  
      Player.reset_count
      game = GameBoard.new
      game.game_round?
    end
  end
  
  game = GameBoard.new
  game.game_round?