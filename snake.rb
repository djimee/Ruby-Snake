require 'ruby2d'

# by default window width is 640, height is 480
set background: 'black'

# no. of pixels 
GRID_SIZE = 20
# width = 640 / 20 = 32
# length = 480 / 20 = 24

class Snake
    def initialize
        @positions = [[2,0], [2,1], [2,2], [2,3]]
        @growing = false
    end
    
    def draw
        @positions.each do |position|
            Square.new(
                x: position[0] * GRID_SIZE, y: position[1] * GRID_SIZE,
                size: GRID_SIZE,
                color: 'white'
            )
        end    
    end
end

snake = Snake.new
snake.draw

show