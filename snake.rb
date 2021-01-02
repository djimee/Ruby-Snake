require 'ruby2d'

set fps_cap: 1
set background: 'black'

# no. of pixels 
GRID_SIZE = 20
# width = 640 / 20 = 32
# length = 480 / 20 = 24

class Snake
    def initialize
        @positions = [[2,0]] # 2D array as snake grows
        @direction = 'right'
    end
    
    def draw
        @positions.each do |position|
            Square.new(
                x: position[0] * GRID_SIZE, y: position[1] * GRID_SIZE,
                size: GRID_SIZE - 1,
                color: 'white'
            )
        end    
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

    def head
        @positions.last
    end
end

snake = Snake.new

update do 
    clear
    snake.move
    snake.draw
end

show