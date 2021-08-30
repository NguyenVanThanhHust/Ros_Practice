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
plt.savefig("images/ode.jpg")
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
plt.savefig("images/sys_equation.jpg")
plt.clf()


# oscilation 1 deg
t0, t1 = 0, 200
t_span = [0, 100]
y0 = [1.0, 2.0]
F0 = 10.0
m = 1.0
omega = 4.1
b = 0.0
c = 16.0

def oscilation_sys(t, y):
    Ft = F0 * np.sin(omega*t)
    funtion = [y[1], 1/m*(Ft - b*y[1]  -c*y[0])]
    return funtion
t_eval, step = np.linspace(start=0, stop=100, num=5000, retstep=True)
sol = solve_ivp(oscilation_sys, t_span, y0, method="RK45", dense_output=True, t_eval=t_eval)


T = sol.t
Y = sol.y
F = [F0 * np.sin(omega*t) for t in T]
plt.plot(T, F, label="force function")
plt.plot(T, Y[0], label="y1")
plt.plot(T, Y[1], label="y2")
plt.legend()
plt.savefig("images/oscilation.jpg")
plt.clf()

# other system of diff equation
# oscilation 1 deg
t0, t1 = 0, 10
t_span = [0, 10]
num_point = 500
init_point = [0.0, 1.0]

def simple_sys(t, y):
    F1 = -y[0]**2 + y[1]
    F2 = -y[0] -y[0]*y[1]
    funtion = [F1, F2]
    return funtion
t_eval, step = np.linspace(start=t_span[0], stop=t_span[1], num=num_point, retstep=True)
sol = solve_ivp(simple_sys, t_span, init_point, method="RK45", dense_output=True, t_eval=t_eval)


T = sol.t
Y = sol.y
F = [F0 * np.sin(omega*t) for t in T]
plt.plot(T, F, label="force function")
plt.plot(T, Y[0], label="y1")
plt.plot(T, Y[1], label="y2")
plt.legend()
plt.savefig("images/simple_sys_1.jpg")
plt.clf()

plt.plot(Y[0], Y[1])
plt.savefig("images/simple_sys_2.jpg")
plt.clf()
