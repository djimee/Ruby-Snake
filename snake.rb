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
    
    def head
        @positions.last
    end

    def move
        case @direction
        when 'up'
            @positions.push([head[0], head[1] - 1])
            @positions.shift
        when 'down'
            @positions.push([head[0], head[1] + 1])
            @positions.shift
        when 'left'
            @positions.push([head[0] - 1, head[1]])
            @positions.shift
        when 'right'
            @positions.push([head[0] + 1, head[1]])
            @positions.shift
        end
    end

    def direction?(new_direction)
        case @direction
        when direction = 'up' then new_direction != 'down'
        when direction = 'down' then new_direction != 'up'
        when direction = 'left' then new_direction != 'right'
        when direction = 'right' then new_direction != 'left'
        end
    end
end

snake = Snake.new

update do 
    clear
    snake.move
    snake.draw
end

on :key_down do |event|
    if ['up', 'down', 'left', 'right'].include?(event.key)
        if snake.direction?(event.key)
            snake.direction = event.key
        end
    end
end

show