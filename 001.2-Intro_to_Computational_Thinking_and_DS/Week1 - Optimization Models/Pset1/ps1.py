###########################
# 6.00.2x Problem Set 1: Space Cows 

from ps1_partition import get_partitions
import time

#================================
# Part A: Transporting Space Cows
#================================

def load_cows(filename):
    """
    Read the contents of the given file.  Assumes the file contents contain
    data in the form of comma-separated cow name, weight pairs, and return a
    dictionary containing cow names as keys and corresponding weights as values.

    Parameters:
    filename - the name of the data file as a string

    Returns:
    a dictionary of cow name (string), weight (int) pairs
    """

    cow_dict = dict()

    f = open(filename, 'r')
    
    for line in f:
        line_data = line.split(',')
        cow_dict[line_data[0]] = int(line_data[1])
    return cow_dict

def find_heaviest_cow(cows):
    """
    produce first heaviest found cow in provided cows that is not in temp_result
    :param cows: a dictionary of name (string), weight (int) pairs
    :param list_of_cows: a list of cows
    :return: tuple
    """
    result = (0, 0)
    for k in cows:
        if cows[k] > result[1]:
            result = (k, cows[k])
    return result

# Problem 1
def greedy_cow_transport(cows,limit=10):
    """
    Uses a greedy heuristic to determine an allocation of cows that attempts to
    minimize the number of spaceship trips needed to transport all the cows. The
    returned allocation of cows may or may not be optimal.
    The greedy heuristic should follow the following method:

    1. As long as the current trip can fit another cow, add the largest cow that will fit
        to the trip
    2. Once the trip is full, begin a new trip to transport the remaining cows

    Does not mutate the given dictionary of cows.

    Parameters:
    cows - a dictionary of name (string), weight (int) pairs
    limit - weight limit of the spaceship (an int)
    
    Returns:
    A list of lists, with each inner list containing the names of cows
    transported on a particular trip and the overall list containing all the
    trips
    """
    cows_copy = dict(cows)
    result = []
    cows_list = []

    for i in range(len(cows_copy)):
        heaviest_cow = find_heaviest_cow(cows_copy)
        cows_list.append(heaviest_cow)
        cows_copy.pop(heaviest_cow[0])

    while len(cows_list) > 0:
        flight_weight = 0
        flight_cows = []
        cows_to_remove = []
        for cow in cows_list:
            if flight_weight + cow[1] <= limit:
                flight_cows.append(cow[0])
                flight_weight += cow[1]
                cows_to_remove.append(cow)
        result.append(flight_cows)
        for cow in cows_to_remove:
            cows_list.remove(cow)
    return result


def partition_weight (part, cows):
    """
    produce sum weight of cows in partition
    :param part: list of cows (partition)
    :param cows: dict of cows and their weights (all cows)
    :return: integer - sum of weight of all cows in partition
    """
    result = 0
    for cow in part:
        result += cows[cow]
    return result


# Problem 2
def brute_force_cow_transport(cows,limit=10):
    """
    Finds the allocation of cows that minimizes the number of spaceship trips
    via brute force.  The brute force algorithm should follow the following method:

    1. Enumerate all possible ways that the cows can be divided into separate trips
    2. Select the allocation that minimizes the number of trips without making any trip
        that does not obey the weight limitation
            
    Does not mutate the given dictionary of cows.

    Parameters:
    cows - a dictionary of name (string), weight (int) pairs
    limit - weight limit of the spaceship (an int)
    
    Returns:
    A list of lists, with each inner list containing the names of cows
    transported on a particular trip and the overall list containing all the
    trips
    """
    result = [[cow] for cow in cows]
    num_of_flights = len(cows)
    parts_gen = get_partitions(cows)
    for parts_set in parts_gen:
        weight_in_limit = False
        for part in parts_set:
            weight_in_limit = False
            if partition_weight(part, cows) > limit:
                break
            else:
                weight_in_limit = True
        if weight_in_limit and len(parts_set) < num_of_flights:
            num_of_flights = len(parts_set)
            result = parts_set
    return result

        
# Problem 3
def compare_cow_transport_algorithms():
    """
    Using the data from ps1_cow_data.txt and the specified weight limit, run your
    greedy_cow_transport and brute_force_cow_transport functions here. Use the
    default weight limits of 10 for both greedy_cow_transport and
    brute_force_cow_transport.
    
    Print out the number of trips returned by each method, and how long each
    method takes to run in seconds.

    Returns:
    Does not return anything.
    """
    # cows = load_cows("ps1_cow_data.txt")
    cows = {'Polaris': 20, 'Louis': 45, 'Horns': 50, 'Clover': 5, 'Muscles': 65, 'Milkshake': 75, 'Lotus': 10, 'Patches': 60, 'Miss Bella': 15, 'MooMoo': 85}
    limit = 100
    result = []
    # functions = [brute_force_cow_transport, greedy_cow_transport]
    # for fn in functions:
    #     start = time.time()
    #     result = fn(cows, limit)
    #     end = time.time()
    #     print(fn, end - start, len(result), result)
    start = time.time()
    result = greedy_cow_transport(cows, limit)
    end = time.time()
    print('Greedy', end - start, len(result), result)
    start = time.time()
    result = brute_force_cow_transport(cows, limit)
    end = time.time()
    print('Brute', end - start, len(result), result)

"""
Here is some test data for you to see the results of your algorithms with. 
Do not submit this along with any of your answers. Uncomment the last two
lines to print the result of your problem.
"""

compare_cow_transport_algorithms()
# cows = {'Polaris': 20, 'Louis': 45, 'Horns': 50, 'Clover': 5, 'Muscles': 65, 'Milkshake': 75, 'Lotus': 10, 'Patches': 60, 'Miss Bella': 15, 'MooMoo': 85}
# cows = load_cows("ps1_cow_data.txt")
# limit=100
# print(cows)
# #
# # print(greedy_cow_transport(cows, limit))
# print(brute_force_cow_transport(cows, limit))

# print(brute_force_cow_transport({'Daisy': 50, 'Buttercup': 72, 'Betsy': 65}, 75))



# print(greedy_cow_transport({'Polaris': 20, 'Louis': 45, 'Horns': 50, 'Clover': 5, 'Muscles': 65, 'Milkshake': 75, 'Lotus': 10, 'Patches': 60, 'Miss Bella': 15, 'MooMoo': 85}, 100))

# print(greedy_cow_transport({'Polaris': 20, 'Louis': 45, 'Horns': 50, 'Clover': 5, 'Muscles': 65, 'Milkshake': 75, 'Lotus': 10, 'Patches': 60, 'Miss Bella': 15, 'MooMoo': 85}, 100) == [['MooMoo', 'Miss Bella'], ['Milkshake', 'Polaris', 'Clover'], ['Muscles', 'Lotus'], ['Patches'], ['Horns', 'Louis']])

# # print(greedy_cow_transport({'Milkshake': 75, 'Horns': 50, 'Patches': 60, 'Lotus': 10, 'Muscles': 65, 'Polaris': 20, 'Clover': 5, 'MooMoo': 85, 'Miss Bella': 15, 'Louis': 45}, 100))
#
# print(greedy_cow_transport({'Polaris': 20, 'Patches': 60, 'MooMoo': 85, 'Louis': 45, 'Milkshake': 75, 'Lotus': 10, 'Horns': 50, 'Miss Bella': 15, 'Clover': 5, 'Muscles': 65}, 100))
# print(greedy_cow_transport({'Willow': 35, 'Lilly': 24, 'Rose': 50, 'Patches': 12, 'Betsy': 65, 'Daisy': 50, 'Buttercup': 72, 'Dottie': 85, 'Abby': 38, 'Coco': 10}, 100))
# print(greedy_cow_transport({'Willow': 59, 'Rose': 42, 'Betsy': 39, 'Luna': 41, 'Buttercup': 11, 'Starlight': 54, 'Abby': 28, 'Coco': 59}, 120))
