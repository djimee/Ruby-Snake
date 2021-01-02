require 'ruby2d'

set fps_cap: 20
set background: 'black'

GRID_SIZE = 20 # no. of pixels 
WIDTH = Window.width / 20 # width = 640 / 20 = 32
HEIGHT = Window.height / 20 # length = 480 / 20 = 24

class Snake
    # attribute writer that allows changing of direction value
    attr_writer :direction

    def initialize 
        @positions = [[2,0]] # 2D array as snake grows
        @direction = 'right'
        @growing = false
    end

    def get_head_x
        return head[0]
    end

    def get_head_y
        return head[1]
    end
    
    def grow
        @growing = true
    end

    def draw
        @positions.each do |position|
            Square.new(
                x: position[0] * GRID_SIZE, y: position[1] * GRID_SIZE,
                size: GRID_SIZE - 1, # -1 to get gaps between squares
                color: 'white'
            )
        end    
    end
    
    # get head of the snake (last element in positions array)
    def head
        return @positions.last
    end

    def move
        case @direction
        when 'up'
            @positions.push(coords(head[0], head[1] - 1))
        when 'down'
            @positions.push(coords(head[0], head[1] + 1))
        when 'left'
            @positions.push(coords(head[0] - 1, head[1]))
        when 'right'
            @positions.push(coords(head[0] + 1, head[1]))
        end

        if !@growing
            @positions.shift
        end

        @growing = false
    end

    # can the snake move in the given direction? i.e. snake cannot turn back on itself
    def direction?(new_direction)
        case @direction
        when direction = 'up' then new_direction != 'down'
        when direction = 'down' then new_direction != 'up'
        when direction = 'left' then new_direction != 'right'
        when direction = 'right' then new_direction != 'left'
        end
    end

    # using the mod function, snake can reappear when going past the border
    def coords(x, y)
        return [x % WIDTH, y % HEIGHT]
    end

    def hit_itself?
        @positions.length != @positions.uniq.length
    end
end

class Game 
    def initialize
        @score = 0
        @x_food = rand(WIDTH)
        @y_food = rand(HEIGHT)
        @finished = false
    end

    def draw_food 
        unless finished?
            Square.new(
                x: @x_food * GRID_SIZE, y: @y_food * GRID_SIZE,
                size: GRID_SIZE,
                color: 'red'
            )
        end
        if finished?
            Text.new("Game over! Final score: #@score")
        else
            Text.new("Score: #@score")
        end
    end

    def eat_food?(x, y)
        return @x_food == x && @y_food == y
    end
    
    def update_hit
        @score += 1
        @x_food = rand(WIDTH)
        @y_food = rand(HEIGHT)
        @growing = true
    end

    def finish
        @finished = true
    end

    def finished?
        @finished
    end
end

snake = Snake.new
game = Game.new

update do 
    clear

    unless game.finished?
        snake.move
    end
    snake.draw
    game.draw_food

    if game.eat_food?(snake.get_head_x, snake.get_head_y)
        game.update_hit
        snake.grow
    end

    if snake.hit_itself?
        game.finish
    end
end

on :key_down do |event|
    if ['up', 'down', 'left', 'right'].include?(event.key)
        if snake.direction?(event.key)
            snake.direction = event.key
        end
    end
end

show