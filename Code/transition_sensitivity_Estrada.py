import matplotlib.pyplot as plt
import numpy as np
import random as rand
import math
import time

# make agents for any prior distribution and n total individuals
def make_prior_nums(prior,n):
    num_priors = np.array([])
    for i in range(0,prior.shape[0]):
        if i == 0:
            num_priors = np.array([(i+1)*np.ones(round(prior[i]*n))])
        else:
            num_priors = np.append(num_priors,np.array([(i+1)*np.ones(round(prior[i]*n))]))
    return num_priors


#Individual agent
#simulates the individual agents for prior_num
def individual_agent_simulation(P,prior_num,num_gens):
    states = P.shape[0]
    post = np.sort(prior_num)
    gens = np.array([post])
    for i in range(0,num_gens):
        for j in range(0,post.shape[0]):
            #generating random number
            r1 = rand.random()
            #generating the new place for new
            counter = 0.0
            for k in range(0,states):
                counter += P[post[j]-1][k]
                if counter>= r1:
                    post[j] = k +1
                    break
        gens=np.append(gens,[post],axis=0)
    return gens

#Plotting the Different generations of each generation data
def plot_generations_data(gens,num_states,start = 0):
    for i in range(start,gens.shape[0]):
        plt.figure(i+1)
        plt.hist(gens[i],num_states)
        plt.title('Generation {}'.format(i+1))
    plt.show()

#calculating the Trace Index
def calculatetrace_index(P):
    t=0
    k = P.shape[0]
    for i in range(0,k):
        t += P[i][i]
    return (k-t)/(k-1.0)

#calculating the bartholemew index
def calculate_barth(P):
    sum1 = 0
    for i in range(0,P.shape[0]):
        for j in range(0,P.shape[1]):
            sum1 += P[i][j]*abs(i-j)
    return sum1 / (P.shape[0]+0.0)

# Plotting the different charts of evolution of bartholomew indexes
def plotting(counter_plots,states,column,full_barths,dt,full_traces):
    # plotting the different barths
    plt.figure(counter_plots)
    plt.plot(full_barths.T)
    plt.title("Bartholemew Indexes vs changes in column {} of size {}".format(column + 1, dt))
    plt.xlabel("n dt changes to column index {}".format(column + 1))
    plt.ylabel("Bartholemew Indexes")
    if states == 5:
        plt.legend(["Row 1", "Row 2", "Row 3", "Row 4", "Row 5"])
    plt.figure(counter_plots+1)
    plt.plot(full_traces.T)
    plt.title("Trace Indexes vs changes in column {} of size {}".format(column + 1, dt))
    plt.xlabel("n dt changes to index column {}".format(column + 1))
    plt.ylabel("trace index changes")
    if states == 5:
        plt.legend(["Row 1", "Row 2", "Row 3", "Row 4", "Row 5"])


#Sensitivity analysis function
# Takes one index and uniformly distributes the differences into the rest of the elements\
def sens_analysis(P,dt,n,show_1):
    states = P.shape[1]
    init_barth = calculate_barth(P)
    init_trace = calculatetrace_index(P)
    counter_plots = 1
    for column in range(0,states):
        for k in range(0,states):
            new_P = np.array([[.421,.245,.153,.102,.079],[.194,.284,.208,.174,.14],[.194,.186,.256,.202,.162],[.125,.182,.198,.252,.243],[.095,.122,.189,.234,.360]])
            barths = np.array([init_barth])
            tindexes = np.array([init_trace])
            if dt!= 0:
                max = int(math.floor(P[k][column]/dt))
            for i in range(0,n):
                for j in range(0,states):
                    if max > i:
                        new_P[k][j] = new_P[k][j] + dt*int(column==j)-(dt/(P.shape[1]-1.0))*int(column!=j)
                barths = np.append(barths,calculate_barth(new_P))
                tindexes = np.append(tindexes, calculatetrace_index(new_P))
            if k == 0:
                full_barths = barths
                full_traces = tindexes
            else:
                full_barths = np.vstack((full_barths,barths))
                full_traces = np.vstack((full_traces,tindexes))
        if column == 0:
            final_barths = full_barths
            final_traces = full_traces
        else:
            final_barths=np.vstack((final_barths,full_barths))
            final_traces= np.vstack((final_traces,full_traces))
        if show_1:
            plotting(counter_plots,states,column,full_barths,dt,full_traces)
            counter_plots+=2
    if show_1:
        plt.show()
    return (final_barths,final_traces)


#importing data into computer
Pw0 = np.array([[.421,.245,.153,.102,.079],[.194,.284,.208,.174,.14],[.194,.186,.256,.202,.162],[.125,.182,.198,.252,.243],[.095,.122,.189,.234,.360]])
Pwithout0 = np.array([[.399,.254,.165,.108,.074],[.205,.262,.208,.186,.139],[.181,.204,.251,.202,.162],[.138,.164,.206,.237,.255],[.098,.117,.166,.259,.360]])


#plotting data
#ngens = individual_agent_simulation(Pw0,make_prior_nums(np.array([1,0,0,0,0]),5000),5)
#plot_generations_data(ngens,5)

#ngens = individual_agent_simulation(Pwithout0,make_prior_nums(np.array([0,0,0,0,1]),5000),5)
#plot_generations_data(ngens,5)

# sensitivity analysis
(b1,t1)=sens_analysis(Pw0,0.001,500,False)
#(b2,t2)=sens_analysis(Pwithout0,.01,200,False)

## Plotting maximum Bartholomew indexes
objects = ('(1,1)','(2,1)','(3,1)','(4,1)','(5,1)','(1,2)','(2,2)','(3,2)','(4,2)','(5,2)','(1,3)','(2,3)','(3,3)','(4,3)','(5,3)','(1,4)','(2,4)','(3,4)','(4,4)','(5,4)','(1,5)','(2,5)','(3,5)','(4,5)','(5,5)')
y_pos = np.arange(len(objects))
max_barths = np.ndarray.max(b1,axis=1)
plt.ylim(ymin = np.min(max_barths)-.05, ymax = np.max(max_barths)+.01)
plt.bar(y_pos, max_barths, align='center', alpha=0.5)
plt.xticks(y_pos, objects)
plt.ylabel('Highest Bartholomew Index Achieved')
plt.title('Highest Bartholomew Index Achieved')
plt.show()

# Plotting maximum Trace indexes
max_traces=np.ndarray.max(t1,axis=1)
plt.bar(y_pos, max_traces, align='center', alpha=0.5)
plt.xticks(y_pos, objects)
plt.ylim(ymin = np.min(max_traces)-.05, ymax = np.max(max_traces)+.01)
plt.ylabel('Highest Trace Index Achieved')
plt.title('Highest Trace Index Achieved for each Index')
plt.show()

# plotting the maximum average achieved by bartholomew and trace index
max_av= np.ndarray.max((b1+t1)/2,axis=1)
plt.bar(y_pos, max_av, align='center', alpha=0.5)
plt.xticks(y_pos, objects)
plt.ylim(ymin = np.min(max_av)-.05, ymax = np.max(max_av)+.01)
plt.ylabel('Highest Trace Index Achieved')
plt.title('Highest Trace Index Achieved for each Index')
plt.show()
