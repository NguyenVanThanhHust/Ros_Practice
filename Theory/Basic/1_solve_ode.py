import os
from scipy import integrate 
from scipy.integrate import solve_ivp

import matplotlib.pyplot as plt
import numpy as np

def equa_1(t, y):
    """
    this is function
    dy/dt = cos(t) with initial condition as y(0)=2
    """
    return np.cos(t)

t0, t1 = 0, 200
t_span = [0, 15]
t_eval, step = np.linspace(start=0, stop=5, num=50, retstep=True)

sol = solve_ivp(equa_1, t_span, [0], method="RK45", dense_output=True, t_eval=t_eval)

T = sol.t
Y = sol.y
plt.plot(T, Y[0])
plt.savefig("ode.jpg")
plt.clf()

# define constant

def equa_sys(t, y):
    """
    dy1/dt = y2
    dy2/dt = a(t) + b*y1 + c*y2)
    y = [y1, y2]
    """
    a_t = 5*np.cos(t)
    function = [y[1],  a_t + 1.0*y[0] + 2.0*y[1] ]
    return function
    
t0, t1 = 0, 200
t_span = [0, 100]
t_eval, step = np.linspace(start=0, stop=5, num=50, retstep=True)

init_point = [1.0, 2.0]
sol = solve_ivp(equa_sys, t_span, init_point, method="RK45", dense_output=True, t_eval=t_eval)


T = sol.t
Y = sol.y
plt.plot(T, Y[0], label="y1")
plt.plot(T, Y[1], label="y2")
plt.legend()
plt.savefig("sys_equation.jpg")
