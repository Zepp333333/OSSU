# 6.00.2x Problem Set 2: Simulating robots
##################
## Comment/uncomment the relevant lines, depending on which version of Python you have
##################

# For Python 3.5:
#from ps2_verify_movement35 import testRobotMovement
# If you get a "Bad magic number" ImportError, you are not using Python 3.5

# For Python 3.6:
#from ps2_verify_movement36 import testRobotMovement
# If you get a "Bad magic number" ImportError, you are not using Python 3.6

import math
import random

import ps2_visualize
import pylab

from ps2_verify_movement37 import testRobotMovement



# === Provided class Position
class Position(object):
    """
    A Position represents a location in a two-dimensional room.
    """
    def __init__(self, x, y):
        """
        Initializes a position with coordinates (x, y).
        """
        self.x = x
        self.y = y

    def getX(self):
        return self.x

    def getY(self):
        return self.y

    def getNewPosition(self, angle, speed):
        """
        Computes and returns the new Position after a single clock-tick has
        passed, with this object as the current position, and with the
        specified angle and speed.

        Does NOT test whether the returned position fits inside the room.

        angle: number representing angle in degrees, 0 <= angle < 360
        speed: positive float representing speed

        Returns: a Position object representing the new position.
        """
        old_x, old_y = self.getX(), self.getY()
        angle = float(angle)
        # Compute the change in position
        delta_y = speed * math.cos(math.radians(angle))
        delta_x = speed * math.sin(math.radians(angle))
        # Add that to the existing position
        new_x = old_x + delta_x
        new_y = old_y + delta_y
        return Position(new_x, new_y)

    def __str__(self):
        return "(%0.2f, %0.2f)" % (self.x, self.y)

import os
os.environ["OPENBLAS_NUM_THREADS"] = "1"
import numpy as np
# === Problem 1
class RectangularRoom(object):
    """
    A RectangularRoom represents a rectangular region containing clean or dirty
    tiles.

    A room has a width and a height and contains (width * height) tiles. At any
    particular time, each of these tiles is either clean or dirty.

    Represented as an np.array(width, height). Dirty tiles = 0, clean = 1.
    """
    def __init__(self, width, height):
        """
        Initializes a rectangular room with the specified width and height.

        Initially, no tiles in the room have been cleaned. (np.array initialized with all zeroes = dirty)

        width: an integer > 0
        height: an integer > 0
        """
        self.width = width
        self.height = height
        self.room = np.zeros((width + 1, height + 1), int)
        #Todo check - maybe should initialize array as width+1 and height+1?


    def cleanTileAtPosition(self, pos):
        """
        Mark the tile under the position POS as cleaned.

        Assumes that POS represents a valid position inside this room.

        pos: a Position
        """
        x = math.floor(pos.getX())
        y = math.floor(pos.getY())
        self.room[x, y] = 1

    def isTileCleaned(self, m, n):
        """
        Return True if the tile (m, n) has been cleaned.

        Assumes that (m, n) represents a valid tile inside the room.

        m: an integer
        n: an integer
        returns: True if (m, n) is cleaned, False otherwise
        """

        if m > self.width or n > self.height:
            raise Exception('Wrong tile coordinates')
        return True if self.room[m, n] == 1 else False

    def getNumTiles(self):
        """
        Return the total number of tiles in the room.

        returns: an integer
        """
        return self.height * self.width

    def getNumCleanedTiles(self):
        """
        Return the total number of clean tiles in the room.

        returns: an integer
        """
        return self.room.sum()

    def getRandomPosition(self):
        """
        Return a random position inside the room.

        returns: a Position object.
        """
        return Position(random.randint(0, self.width-1), random.randint(0, self.height-1))

    def isPositionInRoom(self, pos):
        """
        Return True if pos is inside the room.

        pos: a Position object.
        returns: True if pos is in the room, False otherwise.
        """
        if (pos.getX() >= 0 and pos.getX() < self.width) \
            and (pos.getY() >= 0 and pos.getY() < self.height):
            return True
        else:
            return False




# === Problem 2
class Robot(object):
    """
    Represents a robot cleaning a particular room.

    At all times the robot has a particular position and direction in the room.
    The robot also has a fixed speed.

    Subclasses of Robot should provide movement strategies by implementing
    updatePositionAndClean(), which simulates a single time-step.
    """
    def __init__(self, room, speed):
        """
        Initializes a Robot with the given speed in the specified room. The
        robot initially has a random direction and a random position in the
        room. The robot cleans the tile it is on.

        room:  a RectangularRoom object.
        speed: a float (speed > 0)
        """
        self.room = room
        self.speed = speed
        self.pos = room.getRandomPosition()
        self.direction = random.randint(0, 359)
        self.room.cleanTileAtPosition(self.pos)

    def getRobotPosition(self):
        """
        Return the position of the robot.

        returns: a Position object giving the robot's position.
        """
        return self.pos

    def getRobotDirection(self):
        """
        Return the direction of the robot.

        returns: an integer d giving the direction of the robot as an angle in
        degrees, 0 <= d < 360.
        """
        return self.direction

    def setRobotPosition(self, position):
        """
        Set the position of the robot to POSITION.

        position: a Position object.
        """
        self.pos = position

    def setRobotDirection(self, direction):
        """
        Set the direction of the robot to DIRECTION.

        direction: integer representing an angle in degrees
        """
        self.direction = direction

    def updatePositionAndClean(self):
        """
        Simulate the passage of a single time-step.

        Move the robot to a new position and mark the tile it is on as having
        been cleaned.
        """
        raise NotImplementedError # don't change this!




# === Problem 3
class StandardRobot(Robot):
    """
    A StandardRobot is a Robot with the standard movement strategy.

    At each time-step, a StandardRobot attempts to move in its current
    direction; when it would hit a wall, it *instead* chooses a new direction
    randomly.
    """
    def updatePositionAndClean(self):
        """
        Simulate the passage of a single time-step.

        Move the robot to a new position and mark the tile it is on as having
        been cleaned.
        """
        new_pos = Position.getNewPosition(self.pos, self.direction, self.speed)
        if self.room.isPositionInRoom(new_pos):
            self.setRobotPosition(new_pos)
            self.room.cleanTileAtPosition(self.pos)
        else:
            self.setRobotDirection(random.randint(0, 359))


# Uncomment this line to see your implementation of StandardRobot in action!
# testRobotMovement(StandardRobot, RectangularRoom)




# === Problem 4
'''
def walk(robot, min_coverage):
    """
    Simulate walk of robot until min_coverage % of the room cleaned
    :param robot: is subclass of Robot
    :param min_coverage: a float (0 <= min_coverage <= 1.0)
    :return: # of steps required to clean the min_coverage % of the room
    """
    r_size = robot.room.getNumTiles()
    counter = 0
    while robot.room.getNumCleanedTiles() < r_size * min_coverage:
        robot.updatePositionAndClean()
        counter += 1
    return counter
'''
def walks(robots, min_coverage):
    """
    Simulate walk of robots until min_coverage % of the room cleaned
    :param robot: is list of Robot assuming all robots are in the same room
    :param min_coverage: a float (0 <= min_coverage <= 1.0)
    :return: # of steps required to clean the min_coverage % of the room
    """
    r_size = robots[0].room.getNumTiles()
    counter = 0
    # anim = ps2_visualize.RobotVisualization(len(robots), robots[0].room.width, robots[0].room.height, 0.1)
    while robots[0].room.getNumCleanedTiles() < r_size * min_coverage:
        for r in robots:
            # anim.update(robots[0].room, robots)
            r.updatePositionAndClean()
        counter += 1
    # anim.done()
    return counter
# test for walk
# rm = RectangularRoom(10, 8)
# lor = []
# for i in range(1):
#     lor.append(StandardRobot(rm, 1))
# #rbt = StandardRobot(RectangularRoom(10, 8), 1)
# print(walks(lor, 1))
'''
def simWalks (num_robots, num_trials, min_coverage, robot_type, width, height, speed):


    result = []
    for t in range(num_trials):
        room = RectangularRoom(width, height)
        lor = []     # list of Robots
        for i in range(num_robots):
            lor.append(robot_type(room, speed))
        result.append(walks(lor, min_coverage))
    return sum(result) / len(result)

# Test for simWalks
# rbt = StandardRobot(RectangularRoom(10, 8), 1)
# print(simWalks(10, 100, 0.75, StandardRobot, 10, 8, 1))
'''

def runSimulation(num_robots, speed, width, height, min_coverage, num_trials,
                  robot_type):
    """
    Runs NUM_TRIALS trials of the simulation and returns the mean number of
    time-steps needed to clean the fraction MIN_COVERAGE of the room.

    The simulation is run with NUM_ROBOTS robots of type ROBOT_TYPE, each with
    speed SPEED, in a room of dimensions WIDTH x HEIGHT.

    num_robots: an int (num_robots > 0)
    speed: a float (speed > 0)
    width: an int (width > 0)
    height: an int (height > 0)
    min_coverage: a float (0 <= min_coverage <= 1.0)
    num_trials: an int (num_trials > 0)
    robot_type: class of robot to be instantiated (e.g. StandardRobot or
                RandomWalkRobot)
    """
    result = []
    for t in range(num_trials):
        room = RectangularRoom(width, height)
        lor = []  # list of Robots
        for i in range(num_robots):
            lor.append(robot_type(room, speed))
        result.append(walks(lor, min_coverage))
    return sum(result) / len(result)


# === Problem 5
class RandomWalkRobot(Robot):
    """
    A RandomWalkRobot is a robot with the "random walk" movement strategy: it
    chooses a new direction at random at the end of each time-step.
    """
    def updatePositionAndClean(self):
        """
        Simulate the passage of a single time-step.

        Move the robot to a new position and mark the tile it is on as having
        been cleaned.
        """
        new_pos = Position.getNewPosition(self.pos, self.direction, self.speed)
        if self.room.isPositionInRoom(new_pos):
            self.setRobotPosition(new_pos)
            self.room.cleanTileAtPosition(self.pos)
            self.setRobotDirection(random.randint(0, 359))
        else:
            self.setRobotDirection(random.randint(0, 359))

# Uncomment this line to see how much your simulation takes on average
print(runSimulation(3, 1, 10, 10, 0.75, 1, StandardRobot))
print(runSimulation(3, 1, 10, 10, 0.75, 1, RandomWalkRobot))

def showPlot1(title, x_label, y_label):
    """
    What information does the plot produced by this function tell you?
    """
    num_robot_range = range(1, 11)
    times1 = []
    times2 = []
    for num_robots in num_robot_range:
        print("Plotting", num_robots, "robots...")
        times1.append(runSimulation(num_robots, 1.0, 20, 20, 0.8, 20, StandardRobot))
        times2.append(runSimulation(num_robots, 1.0, 20, 20, 0.8, 20, RandomWalkRobot))
    pylab.plot(num_robot_range, times1)
    pylab.plot(num_robot_range, times2)
    pylab.title(title)
    pylab.legend(('StandardRobot', 'RandomWalkRobot'))
    pylab.xlabel(x_label)
    pylab.ylabel(y_label)
    pylab.show()

# showPlot1("Time It Takes 1 - 10 Robots To Clean 80% Of A Room", "Number of Robots", "Time-steps")

def showPlot2(title, x_label, y_label):
    """
    What information does the plot produced by this function tell you?
    """
    aspect_ratios = []
    times1 = []
    times2 = []
    for width in [10, 20, 25, 50]:
        height = 300//width
        print("Plotting cleaning time for a room of width:", width, "by height:", height)
        aspect_ratios.append(float(width) / height)
        times1.append(runSimulation(2, 1.0, width, height, 0.8, 200, StandardRobot))
        times2.append(runSimulation(2, 1.0, width, height, 0.8, 200, RandomWalkRobot))
    pylab.plot(aspect_ratios, times1)
    pylab.plot(aspect_ratios, times2)
    pylab.title(title)
    pylab.legend(('StandardRobot', 'RandomWalkRobot'))
    pylab.xlabel(x_label)
    pylab.ylabel(y_label)
    pylab.show()

showPlot2("Time It Takes Two Robots To Clean 80% Of Variously Shaped Rooms", "Aspect Ratio", "Time-steps")

# Test code for Room
# print('Init room [5, 4]')
# r = RectangularRoom(10, 5)
# print('Cleaning tile at 2, 3')
# r.cleanTileAtPosition(Position(2,3))
# print(r.room)
# print('Is [3,3] cleaned? ', r.isTileCleaned(3,3))
# print('Is [2,3] cleaned? ', r.isTileCleaned(2,3))
# print('Total tiles', r.getNumTiles())
# print('Cleaned tiles', r.getNumCleanedTiles())
# print('Random position', r.getRandomPosition())
# print('is position 0,0 in room?', r.isPositionInRoom(Position(0,0)))
# print('is position 9.9,4.9 in room?', r.isPositionInRoom(Position(9.9,4.9)))
# print('is position 5,4 in room?', r.isPositionInRoom(Position(5,4)))
# print('is position 6,3 in room?', r.isPositionInRoom(Position(6,3)))
# print('is position 3,6 in room?', r.isPositionInRoom(Position(3,6)))

# Test code for Robot
# robot = StandardRobot(RectangularRoom(10, 8), 1)
# for i in range(10):
#     robot.updatePositionAndClean()
#     print(robot.getRobotPosition(), robot.getRobotDirection())
# print(robot.room.room)
# print(robot.getRobotPosition())
# print(robot.getRobotDirection())
# robot.setRobotPosition(Position(3,3))
# robot.setRobotDirection(15)
# print(robot.getRobotPosition())
# print(robot.getRobotDirection())


# === Problem 6
# NOTE: If you are running the simulation, you will have to close it 
# before the plot will show up.

#
# 1) Write a function call to showPlot1 that generates an appropriately-labeled
#     plot.
#
#       (... your call here ...)
#

#
# 2) Write a function call to showPlot2 that generates an appropriately-labeled
#     plot.
#
#       (... your call here ...)
#
