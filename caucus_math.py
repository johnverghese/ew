from collections import OrderedDict


def final_allocation(dels, allocated):

    #rounding
    dels = [(cand, d, round(d)) for (cand, d) in dels]
    print("rounded:", dels)

    if sum([f[2] for f in dels]) < allocated:

        while sum([f[2] for f in dels]) < allocated:
            farthest_rounded = max([f[1] - f[2] for f in dels])
            dels = [[f[0], f[1], f[2] + 1] if f[1] - f[2] == farthest_rounded else f for f in dels]
            print("Additional delegate allocated: ", dels)
            
    if sum([f[2] for f in dels]) > allocated:

        while sum([f[2] for f in dels]) > allocated:
            farthest_rounded = min([f[1] - f[2] for f in dels if f[2] != 1])
            dels = [[f[0], f[1], f[2] - 1] if f[1] - f[2] == farthest_rounded else f for f in dels]
            print("Delegate removed: ", dels)

    

    

dels = [('A', 2.28), ('B',1.44), ('C',1.32), ('D',0.96)]
allocated = 6
#print(dels)
#final_allocation(dels, allocated)

dels = [('A', 0.82), ('B',0.95), ('C',1.50), ('D',1.71)]
allocated = 5
#print(dels)
#final_allocation(dels, allocated)

#Principle 3, Example B
dels = [('A', 3.06), ('B',3.60)]
allocated = 10
print(dels)
final_allocation(dels, allocated)




